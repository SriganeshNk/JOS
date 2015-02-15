
obj/user/httpd.debug:     file format elf64-x86-64


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
  80003c:	e8 fb 08 00 00       	callq  80093c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  800050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800054:	48 89 c6             	mov    %rax,%rsi
  800057:	48 bf 7c 4e 80 00 00 	movabs $0x804e7c,%rdi
  80005e:	00 00 00 
  800061:	b8 00 00 00 00       	mov    $0x0,%eax
  800066:	48 ba 43 0c 80 00 00 	movabs $0x800c43,%rdx
  80006d:	00 00 00 
  800070:	ff d2                	callq  *%rdx
	exit();
  800072:	48 b8 e4 09 80 00 00 	movabs $0x8009e4,%rax
  800079:	00 00 00 
  80007c:	ff d0                	callq  *%rax
}
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <req_free>:

static void
req_free(struct http_request *req)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 10          	sub    $0x10,%rsp
  800088:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	free(req->url);
  80008c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800090:	48 8b 40 08          	mov    0x8(%rax),%rax
  800094:	48 89 c7             	mov    %rax,%rdi
  800097:	48 b8 e9 3c 80 00 00 	movabs $0x803ce9,%rax
  80009e:	00 00 00 
  8000a1:	ff d0                	callq  *%rax
	free(req->version);
  8000a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000a7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8000ab:	48 89 c7             	mov    %rax,%rdi
  8000ae:	48 b8 e9 3c 80 00 00 	movabs $0x803ce9,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
}
  8000ba:	c9                   	leaveq 
  8000bb:	c3                   	retq   

00000000008000bc <send_header>:

static int
send_header(struct http_request *req, int code)
{
  8000bc:	55                   	push   %rbp
  8000bd:	48 89 e5             	mov    %rsp,%rbp
  8000c0:	48 83 ec 20          	sub    $0x20,%rsp
  8000c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8000c8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	struct responce_header *h = headers;
  8000cb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d2:	00 00 00 
  8000d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (h->code != 0 && h->header!= 0) {
  8000d9:	eb 10                	jmp    8000eb <send_header+0x2f>
		if (h->code == code)
  8000db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000df:	8b 00                	mov    (%rax),%eax
  8000e1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8000e4:	74 1e                	je     800104 <send_header+0x48>
			break;
		h++;
  8000e6:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  8000eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000ef:	8b 00                	mov    (%rax),%eax
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	74 10                	je     800105 <send_header+0x49>
  8000f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8000fd:	48 85 c0             	test   %rax,%rax
  800100:	75 d9                	jne    8000db <send_header+0x1f>
  800102:	eb 01                	jmp    800105 <send_header+0x49>
		if (h->code == code)
			break;
  800104:	90                   	nop
		h++;
	}

	if (h->code == 0)
  800105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800109:	8b 00                	mov    (%rax),%eax
  80010b:	85 c0                	test   %eax,%eax
  80010d:	75 07                	jne    800116 <send_header+0x5a>
		return -1;
  80010f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800114:	eb 5f                	jmp    800175 <send_header+0xb9>

	int len = strlen(h->header);
  800116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80011a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80011e:	48 89 c7             	mov    %rax,%rdi
  800121:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  800128:	00 00 00 
  80012b:	ff d0                	callq  *%rax
  80012d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(req->sock, h->header, len) != len) {
  800130:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800133:	48 63 d0             	movslq %eax,%rdx
  800136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80013a:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80013e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800142:	8b 00                	mov    (%rax),%eax
  800144:	48 89 ce             	mov    %rcx,%rsi
  800147:	89 c7                	mov    %eax,%edi
  800149:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  800150:	00 00 00 
  800153:	ff d0                	callq  *%rax
  800155:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800158:	74 16                	je     800170 <send_header+0xb4>
		die("Failed to send bytes to client");
  80015a:	48 bf 80 4e 80 00 00 	movabs $0x804e80,%rdi
  800161:	00 00 00 
  800164:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
	}

	return 0;
  800170:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800175:	c9                   	leaveq 
  800176:	c3                   	retq   

0000000000800177 <send_data>:

static int
send_data(struct http_request *req, int fd)
{
  800177:	55                   	push   %rbp
  800178:	48 89 e5             	mov    %rsp,%rbp
  80017b:	48 83 ec 10          	sub    $0x10,%rsp
  80017f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800183:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// LAB 6: Your code here.
	panic("send_data not implemented");
  800186:	48 ba 9f 4e 80 00 00 	movabs $0x804e9f,%rdx
  80018d:	00 00 00 
  800190:	be 50 00 00 00       	mov    $0x50,%esi
  800195:	48 bf b9 4e 80 00 00 	movabs $0x804eb9,%rdi
  80019c:	00 00 00 
  80019f:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a4:	48 b9 08 0a 80 00 00 	movabs $0x800a08,%rcx
  8001ab:	00 00 00 
  8001ae:	ff d1                	callq  *%rcx

00000000008001b0 <send_size>:
}

static int
send_size(struct http_request *req, off_t size)
{
  8001b0:	55                   	push   %rbp
  8001b1:	48 89 e5             	mov    %rsp,%rbp
  8001b4:	48 83 ec 60          	sub    $0x60,%rsp
  8001b8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8001bc:	89 75 a4             	mov    %esi,-0x5c(%rbp)
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  8001bf:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8001c2:	48 63 d0             	movslq %eax,%rdx
  8001c5:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8001c9:	48 89 d1             	mov    %rdx,%rcx
  8001cc:	48 ba c6 4e 80 00 00 	movabs $0x804ec6,%rdx
  8001d3:	00 00 00 
  8001d6:	be 40 00 00 00       	mov    $0x40,%esi
  8001db:	48 89 c7             	mov    %rax,%rdi
  8001de:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e3:	49 b8 c5 16 80 00 00 	movabs $0x8016c5,%r8
  8001ea:	00 00 00 
  8001ed:	41 ff d0             	callq  *%r8
  8001f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r > 63)
  8001f3:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  8001f7:	7e 2a                	jle    800223 <send_size+0x73>
		panic("buffer too small!");
  8001f9:	48 ba dc 4e 80 00 00 	movabs $0x804edc,%rdx
  800200:	00 00 00 
  800203:	be 5b 00 00 00       	mov    $0x5b,%esi
  800208:	48 bf b9 4e 80 00 00 	movabs $0x804eb9,%rdi
  80020f:	00 00 00 
  800212:	b8 00 00 00 00       	mov    $0x0,%eax
  800217:	48 b9 08 0a 80 00 00 	movabs $0x800a08,%rcx
  80021e:	00 00 00 
  800221:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  800223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800226:	48 63 d0             	movslq %eax,%rdx
  800229:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80022d:	8b 00                	mov    (%rax),%eax
  80022f:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  800233:	48 89 ce             	mov    %rcx,%rsi
  800236:	89 c7                	mov    %eax,%edi
  800238:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  80023f:	00 00 00 
  800242:	ff d0                	callq  *%rax
  800244:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800247:	74 07                	je     800250 <send_size+0xa0>
		return -1;
  800249:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80024e:	eb 05                	jmp    800255 <send_size+0xa5>

	return 0;
  800250:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800255:	c9                   	leaveq 
  800256:	c3                   	retq   

0000000000800257 <mime_type>:

static const char*
mime_type(const char *file)
{
  800257:	55                   	push   %rbp
  800258:	48 89 e5             	mov    %rsp,%rbp
  80025b:	48 83 ec 08          	sub    $0x8,%rsp
  80025f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	//TODO: for now only a single mime type
	return "text/html";
  800263:	48 b8 ee 4e 80 00 00 	movabs $0x804eee,%rax
  80026a:	00 00 00 
}
  80026d:	c9                   	leaveq 
  80026e:	c3                   	retq   

000000000080026f <send_content_type>:

static int
send_content_type(struct http_request *req)
{
  80026f:	55                   	push   %rbp
  800270:	48 89 e5             	mov    %rsp,%rbp
  800273:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  80027a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
	char buf[128];
	int r;
	const char *type;

	type = mime_type(req->url);
  800281:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800288:	48 8b 40 08          	mov    0x8(%rax),%rax
  80028c:	48 89 c7             	mov    %rax,%rdi
  80028f:	48 b8 57 02 80 00 00 	movabs $0x800257,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
  80029b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!type)
  80029f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8002a4:	75 0a                	jne    8002b0 <send_content_type+0x41>
		return -1;
  8002a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8002ab:	e9 9d 00 00 00       	jmpq   80034d <send_content_type+0xde>

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8002b4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8002bb:	48 89 d1             	mov    %rdx,%rcx
  8002be:	48 ba f8 4e 80 00 00 	movabs $0x804ef8,%rdx
  8002c5:	00 00 00 
  8002c8:	be 80 00 00 00       	mov    $0x80,%esi
  8002cd:	48 89 c7             	mov    %rax,%rdi
  8002d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d5:	49 b8 c5 16 80 00 00 	movabs $0x8016c5,%r8
  8002dc:	00 00 00 
  8002df:	41 ff d0             	callq  *%r8
  8002e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (r > 127)
  8002e5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8002e9:	7e 2a                	jle    800315 <send_content_type+0xa6>
		panic("buffer too small!");
  8002eb:	48 ba dc 4e 80 00 00 	movabs $0x804edc,%rdx
  8002f2:	00 00 00 
  8002f5:	be 77 00 00 00       	mov    $0x77,%esi
  8002fa:	48 bf b9 4e 80 00 00 	movabs $0x804eb9,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	48 b9 08 0a 80 00 00 	movabs $0x800a08,%rcx
  800310:	00 00 00 
  800313:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  800315:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800318:	48 63 d0             	movslq %eax,%rdx
  80031b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800322:	8b 00                	mov    (%rax),%eax
  800324:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  80032b:	48 89 ce             	mov    %rcx,%rsi
  80032e:	89 c7                	mov    %eax,%edi
  800330:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  800337:	00 00 00 
  80033a:	ff d0                	callq  *%rax
  80033c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80033f:	74 07                	je     800348 <send_content_type+0xd9>
		return -1;
  800341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800346:	eb 05                	jmp    80034d <send_content_type+0xde>

	return 0;
  800348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80034d:	c9                   	leaveq 
  80034e:	c3                   	retq   

000000000080034f <send_header_fin>:

static int
send_header_fin(struct http_request *req)
{
  80034f:	55                   	push   %rbp
  800350:	48 89 e5             	mov    %rsp,%rbp
  800353:	48 83 ec 20          	sub    $0x20,%rsp
  800357:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	const char *fin = "\r\n";
  80035b:	48 b8 0b 4f 80 00 00 	movabs $0x804f0b,%rax
  800362:	00 00 00 
  800365:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int fin_len = strlen(fin);
  800369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80036d:	48 89 c7             	mov    %rax,%rdi
  800370:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  800377:	00 00 00 
  80037a:	ff d0                	callq  *%rax
  80037c:	89 45 f4             	mov    %eax,-0xc(%rbp)

	if (write(req->sock, fin, fin_len) != fin_len)
  80037f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800382:	48 63 d0             	movslq %eax,%rdx
  800385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800389:	8b 00                	mov    (%rax),%eax
  80038b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80038f:	48 89 ce             	mov    %rcx,%rsi
  800392:	89 c7                	mov    %eax,%edi
  800394:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  80039b:	00 00 00 
  80039e:	ff d0                	callq  *%rax
  8003a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8003a3:	74 07                	je     8003ac <send_header_fin+0x5d>
		return -1;
  8003a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8003aa:	eb 05                	jmp    8003b1 <send_header_fin+0x62>

	return 0;
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003b1:	c9                   	leaveq 
  8003b2:	c3                   	retq   

00000000008003b3 <http_request_parse>:

// given a request, this function creates a struct http_request
static int
http_request_parse(struct http_request *req, char *request)
{
  8003b3:	55                   	push   %rbp
  8003b4:	48 89 e5             	mov    %rsp,%rbp
  8003b7:	48 83 ec 30          	sub    $0x30,%rsp
  8003bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8003bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	const char *url;
	const char *version;
	int url_len, version_len;

	if (!req)
  8003c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003c8:	75 0a                	jne    8003d4 <http_request_parse+0x21>
		return -1;
  8003ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8003cf:	e9 5d 01 00 00       	jmpq   800531 <http_request_parse+0x17e>

	if (strncmp(request, "GET ", 4) != 0)
  8003d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8003d8:	ba 04 00 00 00       	mov    $0x4,%edx
  8003dd:	48 be 0e 4f 80 00 00 	movabs $0x804f0e,%rsi
  8003e4:	00 00 00 
  8003e7:	48 89 c7             	mov    %rax,%rdi
  8003ea:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  8003f1:	00 00 00 
  8003f4:	ff d0                	callq  *%rax
  8003f6:	85 c0                	test   %eax,%eax
  8003f8:	74 0a                	je     800404 <http_request_parse+0x51>
		return -E_BAD_REQ;
  8003fa:	b8 18 fc ff ff       	mov    $0xfffffc18,%eax
  8003ff:	e9 2d 01 00 00       	jmpq   800531 <http_request_parse+0x17e>

	// skip GET
	request += 4;
  800404:	48 83 45 d0 04       	addq   $0x4,-0x30(%rbp)

	// get the url
	url = request;
  800409:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80040d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (*request && *request != ' ')
  800411:	eb 05                	jmp    800418 <http_request_parse+0x65>
		request++;
  800413:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  800418:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80041c:	0f b6 00             	movzbl (%rax),%eax
  80041f:	84 c0                	test   %al,%al
  800421:	74 0b                	je     80042e <http_request_parse+0x7b>
  800423:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800427:	0f b6 00             	movzbl (%rax),%eax
  80042a:	3c 20                	cmp    $0x20,%al
  80042c:	75 e5                	jne    800413 <http_request_parse+0x60>
		request++;
	url_len = request - url;
  80042e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800436:	48 89 d1             	mov    %rdx,%rcx
  800439:	48 29 c1             	sub    %rax,%rcx
  80043c:	48 89 c8             	mov    %rcx,%rax
  80043f:	89 45 f4             	mov    %eax,-0xc(%rbp)

	req->url = malloc(url_len + 1);
  800442:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800445:	83 c0 01             	add    $0x1,%eax
  800448:	48 98                	cltq   
  80044a:	48 89 c7             	mov    %rax,%rdi
  80044d:	48 b8 69 39 80 00 00 	movabs $0x803969,%rax
  800454:	00 00 00 
  800457:	ff d0                	callq  *%rax
  800459:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80045d:	48 89 42 08          	mov    %rax,0x8(%rdx)
	memmove(req->url, url, url_len);
  800461:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800464:	48 63 d0             	movslq %eax,%rdx
  800467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80046b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80046f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800473:	48 89 ce             	mov    %rcx,%rsi
  800476:	48 89 c7             	mov    %rax,%rdi
  800479:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  800480:	00 00 00 
  800483:	ff d0                	callq  *%rax
	req->url[url_len] = '\0';
  800485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800489:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80048d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800490:	48 98                	cltq   
  800492:	48 01 d0             	add    %rdx,%rax
  800495:	c6 00 00             	movb   $0x0,(%rax)

	// skip space
	request++;
  800498:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	version = request;
  80049d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004a1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (*request && *request != '\n')
  8004a5:	eb 05                	jmp    8004ac <http_request_parse+0xf9>
		request++;
  8004a7:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  8004ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004b0:	0f b6 00             	movzbl (%rax),%eax
  8004b3:	84 c0                	test   %al,%al
  8004b5:	74 0b                	je     8004c2 <http_request_parse+0x10f>
  8004b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004bb:	0f b6 00             	movzbl (%rax),%eax
  8004be:	3c 0a                	cmp    $0xa,%al
  8004c0:	75 e5                	jne    8004a7 <http_request_parse+0xf4>
		request++;
	version_len = request - version;
  8004c2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 89 d1             	mov    %rdx,%rcx
  8004cd:	48 29 c1             	sub    %rax,%rcx
  8004d0:	48 89 c8             	mov    %rcx,%rax
  8004d3:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	req->version = malloc(version_len + 1);
  8004d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004d9:	83 c0 01             	add    $0x1,%eax
  8004dc:	48 98                	cltq   
  8004de:	48 89 c7             	mov    %rax,%rdi
  8004e1:	48 b8 69 39 80 00 00 	movabs $0x803969,%rax
  8004e8:	00 00 00 
  8004eb:	ff d0                	callq  *%rax
  8004ed:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004f1:	48 89 42 10          	mov    %rax,0x10(%rdx)
	memmove(req->version, version, version_len);
  8004f5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004f8:	48 63 d0             	movslq %eax,%rdx
  8004fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004ff:	48 8b 40 10          	mov    0x10(%rax),%rax
  800503:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800507:	48 89 ce             	mov    %rcx,%rsi
  80050a:	48 89 c7             	mov    %rax,%rdi
  80050d:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  800514:	00 00 00 
  800517:	ff d0                	callq  *%rax
	req->version[version_len] = '\0';
  800519:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800521:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800524:	48 98                	cltq   
  800526:	48 01 d0             	add    %rdx,%rax
  800529:	c6 00 00             	movb   $0x0,(%rax)

	// no entity parsing

	return 0;
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800531:	c9                   	leaveq 
  800532:	c3                   	retq   

0000000000800533 <send_error>:

static int
send_error(struct http_request *req, int code)
{
  800533:	55                   	push   %rbp
  800534:	48 89 e5             	mov    %rsp,%rbp
  800537:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
  80053e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  800545:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%rbp)
	char buf[512];
	int r;

	struct error_messages *e = errors;
  80054b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800552:	00 00 00 
  800555:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->code != 0 && e->msg != 0) {
  800559:	eb 13                	jmp    80056e <send_error+0x3b>
		if (e->code == code)
  80055b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80055f:	8b 00                	mov    (%rax),%eax
  800561:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  800567:	74 1e                	je     800587 <send_error+0x54>
			break;
		e++;
  800569:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  80056e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800572:	8b 00                	mov    (%rax),%eax
  800574:	85 c0                	test   %eax,%eax
  800576:	74 10                	je     800588 <send_error+0x55>
  800578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80057c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800580:	48 85 c0             	test   %rax,%rax
  800583:	75 d6                	jne    80055b <send_error+0x28>
  800585:	eb 01                	jmp    800588 <send_error+0x55>
		if (e->code == code)
			break;
  800587:	90                   	nop
		e++;
	}

	if (e->code == 0)
  800588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80058c:	8b 00                	mov    (%rax),%eax
  80058e:	85 c0                	test   %eax,%eax
  800590:	75 0a                	jne    80059c <send_error+0x69>
		return -1;
  800592:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800597:	e9 8e 00 00 00       	jmpq   80062a <send_error+0xf7>
		     "Server: jhttpd/" VERSION "\r\n"
		     "Connection: close"
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);
  80059c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  8005a0:	48 8b 48 08          	mov    0x8(%rax),%rcx
		     "Server: jhttpd/" VERSION "\r\n"
		     "Connection: close"
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);
  8005a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  8005a8:	8b 38                	mov    (%rax),%edi
		     "Server: jhttpd/" VERSION "\r\n"
		     "Connection: close"
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);
  8005aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  8005ae:	48 8b 70 08          	mov    0x8(%rax),%rsi
		     "Server: jhttpd/" VERSION "\r\n"
		     "Connection: close"
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);
  8005b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  8005b6:	8b 10                	mov    (%rax),%edx
  8005b8:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  8005bf:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005c3:	41 89 f9             	mov    %edi,%r9d
  8005c6:	49 89 f0             	mov    %rsi,%r8
  8005c9:	89 d1                	mov    %edx,%ecx
  8005cb:	48 ba 18 4f 80 00 00 	movabs $0x804f18,%rdx
  8005d2:	00 00 00 
  8005d5:	be 00 02 00 00       	mov    $0x200,%esi
  8005da:	48 89 c7             	mov    %rax,%rdi
  8005dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e2:	49 ba c5 16 80 00 00 	movabs $0x8016c5,%r10
  8005e9:	00 00 00 
  8005ec:	41 ff d2             	callq  *%r10
  8005ef:	89 45 f4             	mov    %eax,-0xc(%rbp)
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8005f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8005f5:	48 63 d0             	movslq %eax,%rdx
  8005f8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8005ff:	8b 00                	mov    (%rax),%eax
  800601:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800608:	48 89 ce             	mov    %rcx,%rsi
  80060b:	89 c7                	mov    %eax,%edi
  80060d:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  800614:	00 00 00 
  800617:	ff d0                	callq  *%rax
  800619:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80061c:	74 07                	je     800625 <send_error+0xf2>
		return -1;
  80061e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800623:	eb 05                	jmp    80062a <send_error+0xf7>

	return 0;
  800625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80062a:	c9                   	leaveq 
  80062b:	c3                   	retq   

000000000080062c <send_file>:

static int
send_file(struct http_request *req)
{
  80062c:	55                   	push   %rbp
  80062d:	48 89 e5             	mov    %rsp,%rbp
  800630:	48 83 ec 20          	sub    $0x20,%rsp
  800634:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	off_t file_size = -1;
  800638:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// if the file does not exist, send a 404 error using send_error
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.
	panic("send_file not implemented");
  80063f:	48 ba 93 4f 80 00 00 	movabs $0x804f93,%rdx
  800646:	00 00 00 
  800649:	be e2 00 00 00       	mov    $0xe2,%esi
  80064e:	48 bf b9 4e 80 00 00 	movabs $0x804eb9,%rdi
  800655:	00 00 00 
  800658:	b8 00 00 00 00       	mov    $0x0,%eax
  80065d:	48 b9 08 0a 80 00 00 	movabs $0x800a08,%rcx
  800664:	00 00 00 
  800667:	ff d1                	callq  *%rcx

0000000000800669 <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  800669:	55                   	push   %rbp
  80066a:	48 89 e5             	mov    %rsp,%rbp
  80066d:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  800674:	89 bd cc fd ff ff    	mov    %edi,-0x234(%rbp)
	struct http_request con_d;
	int r;
	char buffer[BUFFSIZE];
	int received = -1;
  80067a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	struct http_request *req = &con_d;
  800681:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800685:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800689:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  800690:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  800696:	ba 00 02 00 00       	mov    $0x200,%edx
  80069b:	48 89 ce             	mov    %rcx,%rsi
  80069e:	89 c7                	mov    %eax,%edi
  8006a0:	48 b8 b4 29 80 00 00 	movabs $0x8029b4,%rax
  8006a7:	00 00 00 
  8006aa:	ff d0                	callq  *%rax
  8006ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8006af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006b3:	79 2a                	jns    8006df <handle_client+0x76>
			panic("failed to read");
  8006b5:	48 ba ad 4f 80 00 00 	movabs $0x804fad,%rdx
  8006bc:	00 00 00 
  8006bf:	be 04 01 00 00       	mov    $0x104,%esi
  8006c4:	48 bf b9 4e 80 00 00 	movabs $0x804eb9,%rdi
  8006cb:	00 00 00 
  8006ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d3:	48 b9 08 0a 80 00 00 	movabs $0x800a08,%rcx
  8006da:	00 00 00 
  8006dd:	ff d1                	callq  *%rcx

		memset(req, 0, sizeof(req));
  8006df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e3:	ba 08 00 00 00       	mov    $0x8,%edx
  8006e8:	be 00 00 00 00       	mov    $0x0,%esi
  8006ed:	48 89 c7             	mov    %rax,%rdi
  8006f0:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  8006f7:	00 00 00 
  8006fa:	ff d0                	callq  *%rax

		req->sock = sock;
  8006fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800700:	8b 95 cc fd ff ff    	mov    -0x234(%rbp),%edx
  800706:	89 10                	mov    %edx,(%rax)

		r = http_request_parse(req, buffer);
  800708:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80070f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800713:	48 89 d6             	mov    %rdx,%rsi
  800716:	48 89 c7             	mov    %rax,%rdi
  800719:	48 b8 b3 03 80 00 00 	movabs $0x8003b3,%rax
  800720:	00 00 00 
  800723:	ff d0                	callq  *%rax
  800725:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r == -E_BAD_REQ)
  800728:	81 7d ec 18 fc ff ff 	cmpl   $0xfffffc18,-0x14(%rbp)
  80072f:	75 1a                	jne    80074b <handle_client+0xe2>
			send_error(req, 400);
  800731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800735:	be 90 01 00 00       	mov    $0x190,%esi
  80073a:	48 89 c7             	mov    %rax,%rdi
  80073d:	48 b8 33 05 80 00 00 	movabs $0x800533,%rax
  800744:	00 00 00 
  800747:	ff d0                	callq  *%rax
  800749:	eb 43                	jmp    80078e <handle_client+0x125>
		else if (r < 0)
  80074b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80074f:	79 2a                	jns    80077b <handle_client+0x112>
			panic("parse failed");
  800751:	48 ba bc 4f 80 00 00 	movabs $0x804fbc,%rdx
  800758:	00 00 00 
  80075b:	be 0e 01 00 00       	mov    $0x10e,%esi
  800760:	48 bf b9 4e 80 00 00 	movabs $0x804eb9,%rdi
  800767:	00 00 00 
  80076a:	b8 00 00 00 00       	mov    $0x0,%eax
  80076f:	48 b9 08 0a 80 00 00 	movabs $0x800a08,%rcx
  800776:	00 00 00 
  800779:	ff d1                	callq  *%rcx
		else
			send_file(req);
  80077b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80077f:	48 89 c7             	mov    %rax,%rdi
  800782:	48 b8 2c 06 80 00 00 	movabs $0x80062c,%rax
  800789:	00 00 00 
  80078c:	ff d0                	callq  *%rax

		req_free(req);
  80078e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800792:	48 89 c7             	mov    %rax,%rdi
  800795:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  80079c:	00 00 00 
  80079f:	ff d0                	callq  *%rax

		// no keep alive
		break;
  8007a1:	90                   	nop
	}

	close(sock);
  8007a2:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
}
  8007b6:	c9                   	leaveq 
  8007b7:	c3                   	retq   

00000000008007b8 <umain>:

void
umain(int argc, char **argv)
{
  8007b8:	55                   	push   %rbp
  8007b9:	48 89 e5             	mov    %rsp,%rbp
  8007bc:	48 83 ec 50          	sub    $0x50,%rsp
  8007c0:	89 7d bc             	mov    %edi,-0x44(%rbp)
  8007c3:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8007c7:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8007ce:	00 00 00 
  8007d1:	48 ba c9 4f 80 00 00 	movabs $0x804fc9,%rdx
  8007d8:	00 00 00 
  8007db:	48 89 10             	mov    %rdx,(%rax)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8007de:	ba 06 00 00 00       	mov    $0x6,%edx
  8007e3:	be 01 00 00 00       	mov    $0x1,%esi
  8007e8:	bf 02 00 00 00       	mov    $0x2,%edi
  8007ed:	48 b8 39 34 80 00 00 	movabs $0x803439,%rax
  8007f4:	00 00 00 
  8007f7:	ff d0                	callq  *%rax
  8007f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800800:	79 16                	jns    800818 <umain+0x60>
		die("Failed to create socket");
  800802:	48 bf d0 4f 80 00 00 	movabs $0x804fd0,%rdi
  800809:	00 00 00 
  80080c:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800813:	00 00 00 
  800816:	ff d0                	callq  *%rax

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800818:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  80081c:	ba 10 00 00 00       	mov    $0x10,%edx
  800821:	be 00 00 00 00       	mov    $0x0,%esi
  800826:	48 89 c7             	mov    %rax,%rdi
  800829:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  800830:	00 00 00 
  800833:	ff d0                	callq  *%rax
	server.sin_family = AF_INET;			// Internet/IP
  800835:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800839:	bf 00 00 00 00       	mov    $0x0,%edi
  80083e:	48 b8 d5 4d 80 00 00 	movabs $0x804dd5,%rax
  800845:	00 00 00 
  800848:	ff d0                	callq  *%rax
  80084a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	server.sin_port = htons(PORT);			// server port
  80084d:	bf 50 00 00 00       	mov    $0x50,%edi
  800852:	48 b8 90 4d 80 00 00 	movabs $0x804d90,%rax
  800859:	00 00 00 
  80085c:	ff d0                	callq  *%rax
  80085e:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800862:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800869:	ba 10 00 00 00       	mov    $0x10,%edx
  80086e:	48 89 ce             	mov    %rcx,%rsi
  800871:	89 c7                	mov    %eax,%edi
  800873:	48 b8 29 32 80 00 00 	movabs $0x803229,%rax
  80087a:	00 00 00 
  80087d:	ff d0                	callq  *%rax
  80087f:	85 c0                	test   %eax,%eax
  800881:	79 16                	jns    800899 <umain+0xe1>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  800883:	48 bf e8 4f 80 00 00 	movabs $0x804fe8,%rdi
  80088a:	00 00 00 
  80088d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800894:	00 00 00 
  800897:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80089c:	be 05 00 00 00       	mov    $0x5,%esi
  8008a1:	89 c7                	mov    %eax,%edi
  8008a3:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  8008aa:	00 00 00 
  8008ad:	ff d0                	callq  *%rax
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	79 16                	jns    8008c9 <umain+0x111>
		die("Failed to listen on server socket");
  8008b3:	48 bf 10 50 80 00 00 	movabs $0x805010,%rdi
  8008ba:	00 00 00 
  8008bd:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8008c4:	00 00 00 
  8008c7:	ff d0                	callq  *%rax

	cprintf("Waiting for http connections...\n");
  8008c9:	48 bf 38 50 80 00 00 	movabs $0x805038,%rdi
  8008d0:	00 00 00 
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d8:	48 ba 43 0c 80 00 00 	movabs $0x800c43,%rdx
  8008df:	00 00 00 
  8008e2:	ff d2                	callq  *%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
  8008e4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
  8008eb:	48 8d 55 cc          	lea    -0x34(%rbp),%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
					 (struct sockaddr *) &client,
  8008ef:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  8008f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008f6:	48 89 ce             	mov    %rcx,%rsi
  8008f9:	89 c7                	mov    %eax,%edi
  8008fb:	48 b8 ba 31 80 00 00 	movabs $0x8031ba,%rax
  800902:	00 00 00 
  800905:	ff d0                	callq  *%rax
  800907:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80090a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80090e:	79 16                	jns    800926 <umain+0x16e>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800910:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  800917:	00 00 00 
  80091a:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800921:	00 00 00 
  800924:	ff d0                	callq  *%rax
		}
		handle_client(clientsock);
  800926:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800929:	89 c7                	mov    %eax,%edi
  80092b:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800932:	00 00 00 
  800935:	ff d0                	callq  *%rax
	}
  800937:	eb ab                	jmp    8008e4 <umain+0x12c>
  800939:	00 00                	add    %al,(%rax)
	...

000000000080093c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80093c:	55                   	push   %rbp
  80093d:	48 89 e5             	mov    %rsp,%rbp
  800940:	48 83 ec 10          	sub    $0x10,%rsp
  800944:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800947:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80094b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800952:	00 00 00 
  800955:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  80095c:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  800963:	00 00 00 
  800966:	ff d0                	callq  *%rax
  800968:	48 98                	cltq   
  80096a:	48 89 c2             	mov    %rax,%rdx
  80096d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800973:	48 89 d0             	mov    %rdx,%rax
  800976:	48 c1 e0 02          	shl    $0x2,%rax
  80097a:	48 01 d0             	add    %rdx,%rax
  80097d:	48 01 c0             	add    %rax,%rax
  800980:	48 01 d0             	add    %rdx,%rax
  800983:	48 c1 e0 05          	shl    $0x5,%rax
  800987:	48 89 c2             	mov    %rax,%rdx
  80098a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800991:	00 00 00 
  800994:	48 01 c2             	add    %rax,%rdx
  800997:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80099e:	00 00 00 
  8009a1:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009a8:	7e 14                	jle    8009be <libmain+0x82>
		binaryname = argv[0];
  8009aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009ae:	48 8b 10             	mov    (%rax),%rdx
  8009b1:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8009b8:	00 00 00 
  8009bb:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8009be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009c5:	48 89 d6             	mov    %rdx,%rsi
  8009c8:	89 c7                	mov    %eax,%edi
  8009ca:	48 b8 b8 07 80 00 00 	movabs $0x8007b8,%rax
  8009d1:	00 00 00 
  8009d4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8009d6:	48 b8 e4 09 80 00 00 	movabs $0x8009e4,%rax
  8009dd:	00 00 00 
  8009e0:	ff d0                	callq  *%rax
}
  8009e2:	c9                   	leaveq 
  8009e3:	c3                   	retq   

00000000008009e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8009e4:	55                   	push   %rbp
  8009e5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8009e8:	48 b8 dd 27 80 00 00 	movabs $0x8027dd,%rax
  8009ef:	00 00 00 
  8009f2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8009f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8009f9:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
}
  800a05:	5d                   	pop    %rbp
  800a06:	c3                   	retq   
	...

0000000000800a08 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a08:	55                   	push   %rbp
  800a09:	48 89 e5             	mov    %rsp,%rbp
  800a0c:	53                   	push   %rbx
  800a0d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800a14:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800a1b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800a21:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800a28:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800a2f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800a36:	84 c0                	test   %al,%al
  800a38:	74 23                	je     800a5d <_panic+0x55>
  800a3a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800a41:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800a45:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800a49:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800a4d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800a51:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800a55:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800a59:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800a5d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800a64:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800a6b:	00 00 00 
  800a6e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800a75:	00 00 00 
  800a78:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800a7c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800a83:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800a8a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a91:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800a98:	00 00 00 
  800a9b:	48 8b 18             	mov    (%rax),%rbx
  800a9e:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  800aa5:	00 00 00 
  800aa8:	ff d0                	callq  *%rax
  800aaa:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800ab0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ab7:	41 89 c8             	mov    %ecx,%r8d
  800aba:	48 89 d1             	mov    %rdx,%rcx
  800abd:	48 89 da             	mov    %rbx,%rdx
  800ac0:	89 c6                	mov    %eax,%esi
  800ac2:	48 bf 90 50 80 00 00 	movabs $0x805090,%rdi
  800ac9:	00 00 00 
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad1:	49 b9 43 0c 80 00 00 	movabs $0x800c43,%r9
  800ad8:	00 00 00 
  800adb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ade:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800ae5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800aec:	48 89 d6             	mov    %rdx,%rsi
  800aef:	48 89 c7             	mov    %rax,%rdi
  800af2:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  800af9:	00 00 00 
  800afc:	ff d0                	callq  *%rax
	cprintf("\n");
  800afe:	48 bf b3 50 80 00 00 	movabs $0x8050b3,%rdi
  800b05:	00 00 00 
  800b08:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0d:	48 ba 43 0c 80 00 00 	movabs $0x800c43,%rdx
  800b14:	00 00 00 
  800b17:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800b19:	cc                   	int3   
  800b1a:	eb fd                	jmp    800b19 <_panic+0x111>

0000000000800b1c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800b1c:	55                   	push   %rbp
  800b1d:	48 89 e5             	mov    %rsp,%rbp
  800b20:	48 83 ec 10          	sub    $0x10,%rsp
  800b24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800b27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b2f:	8b 00                	mov    (%rax),%eax
  800b31:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800b34:	89 d6                	mov    %edx,%esi
  800b36:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800b3a:	48 63 d0             	movslq %eax,%rdx
  800b3d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800b42:	8d 50 01             	lea    0x1(%rax),%edx
  800b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b49:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b4f:	8b 00                	mov    (%rax),%eax
  800b51:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b56:	75 2c                	jne    800b84 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b5c:	8b 00                	mov    (%rax),%eax
  800b5e:	48 98                	cltq   
  800b60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b64:	48 83 c2 08          	add    $0x8,%rdx
  800b68:	48 89 c6             	mov    %rax,%rsi
  800b6b:	48 89 d7             	mov    %rdx,%rdi
  800b6e:	48 b8 04 20 80 00 00 	movabs $0x802004,%rax
  800b75:	00 00 00 
  800b78:	ff d0                	callq  *%rax
        b->idx = 0;
  800b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b7e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800b84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b88:	8b 40 04             	mov    0x4(%rax),%eax
  800b8b:	8d 50 01             	lea    0x1(%rax),%edx
  800b8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b92:	89 50 04             	mov    %edx,0x4(%rax)
}
  800b95:	c9                   	leaveq 
  800b96:	c3                   	retq   

0000000000800b97 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800b97:	55                   	push   %rbp
  800b98:	48 89 e5             	mov    %rsp,%rbp
  800b9b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800ba2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ba9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800bb0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800bb7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800bbe:	48 8b 0a             	mov    (%rdx),%rcx
  800bc1:	48 89 08             	mov    %rcx,(%rax)
  800bc4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bc8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bcc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bd0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800bd4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800bdb:	00 00 00 
    b.cnt = 0;
  800bde:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800be5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800be8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800bef:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800bf6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800bfd:	48 89 c6             	mov    %rax,%rsi
  800c00:	48 bf 1c 0b 80 00 00 	movabs $0x800b1c,%rdi
  800c07:	00 00 00 
  800c0a:	48 b8 f4 0f 80 00 00 	movabs $0x800ff4,%rax
  800c11:	00 00 00 
  800c14:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800c16:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800c1c:	48 98                	cltq   
  800c1e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800c25:	48 83 c2 08          	add    $0x8,%rdx
  800c29:	48 89 c6             	mov    %rax,%rsi
  800c2c:	48 89 d7             	mov    %rdx,%rdi
  800c2f:	48 b8 04 20 80 00 00 	movabs $0x802004,%rax
  800c36:	00 00 00 
  800c39:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800c3b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800c41:	c9                   	leaveq 
  800c42:	c3                   	retq   

0000000000800c43 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800c43:	55                   	push   %rbp
  800c44:	48 89 e5             	mov    %rsp,%rbp
  800c47:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800c4e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800c55:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800c5c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c63:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c6a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c71:	84 c0                	test   %al,%al
  800c73:	74 20                	je     800c95 <cprintf+0x52>
  800c75:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c79:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c7d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c81:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c85:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c89:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c8d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c91:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c95:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800c9c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800ca3:	00 00 00 
  800ca6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800cad:	00 00 00 
  800cb0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cb4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800cbb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cc2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800cc9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800cd0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800cd7:	48 8b 0a             	mov    (%rdx),%rcx
  800cda:	48 89 08             	mov    %rcx,(%rax)
  800cdd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ce1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ce5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ce9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800ced:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800cf4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800cfb:	48 89 d6             	mov    %rdx,%rsi
  800cfe:	48 89 c7             	mov    %rax,%rdi
  800d01:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  800d08:	00 00 00 
  800d0b:	ff d0                	callq  *%rax
  800d0d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800d13:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d19:	c9                   	leaveq 
  800d1a:	c3                   	retq   
	...

0000000000800d1c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d1c:	55                   	push   %rbp
  800d1d:	48 89 e5             	mov    %rsp,%rbp
  800d20:	48 83 ec 30          	sub    $0x30,%rsp
  800d24:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800d28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d2c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d30:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800d33:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800d37:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d3b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800d3e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800d42:	77 52                	ja     800d96 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d44:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800d47:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800d4b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800d4e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d56:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5b:	48 f7 75 d0          	divq   -0x30(%rbp)
  800d5f:	48 89 c2             	mov    %rax,%rdx
  800d62:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d65:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d68:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800d6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800d70:	41 89 f9             	mov    %edi,%r9d
  800d73:	48 89 c7             	mov    %rax,%rdi
  800d76:	48 b8 1c 0d 80 00 00 	movabs $0x800d1c,%rax
  800d7d:	00 00 00 
  800d80:	ff d0                	callq  *%rax
  800d82:	eb 1c                	jmp    800da0 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d88:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d8b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800d8f:	48 89 d6             	mov    %rdx,%rsi
  800d92:	89 c7                	mov    %eax,%edi
  800d94:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d96:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800d9a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800d9e:	7f e4                	jg     800d84 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800da0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800da3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dac:	48 f7 f1             	div    %rcx
  800daf:	48 89 d0             	mov    %rdx,%rax
  800db2:	48 ba b0 52 80 00 00 	movabs $0x8052b0,%rdx
  800db9:	00 00 00 
  800dbc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800dc0:	0f be c0             	movsbl %al,%eax
  800dc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800dc7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800dcb:	48 89 d6             	mov    %rdx,%rsi
  800dce:	89 c7                	mov    %eax,%edi
  800dd0:	ff d1                	callq  *%rcx
}
  800dd2:	c9                   	leaveq 
  800dd3:	c3                   	retq   

0000000000800dd4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800dd4:	55                   	push   %rbp
  800dd5:	48 89 e5             	mov    %rsp,%rbp
  800dd8:	48 83 ec 20          	sub    $0x20,%rsp
  800ddc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800de0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800de3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800de7:	7e 52                	jle    800e3b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ded:	8b 00                	mov    (%rax),%eax
  800def:	83 f8 30             	cmp    $0x30,%eax
  800df2:	73 24                	jae    800e18 <getuint+0x44>
  800df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800dfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e00:	8b 00                	mov    (%rax),%eax
  800e02:	89 c0                	mov    %eax,%eax
  800e04:	48 01 d0             	add    %rdx,%rax
  800e07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e0b:	8b 12                	mov    (%rdx),%edx
  800e0d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e14:	89 0a                	mov    %ecx,(%rdx)
  800e16:	eb 17                	jmp    800e2f <getuint+0x5b>
  800e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e20:	48 89 d0             	mov    %rdx,%rax
  800e23:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e27:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e2b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e2f:	48 8b 00             	mov    (%rax),%rax
  800e32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e36:	e9 a3 00 00 00       	jmpq   800ede <getuint+0x10a>
	else if (lflag)
  800e3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e3f:	74 4f                	je     800e90 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800e41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e45:	8b 00                	mov    (%rax),%eax
  800e47:	83 f8 30             	cmp    $0x30,%eax
  800e4a:	73 24                	jae    800e70 <getuint+0x9c>
  800e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e50:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e58:	8b 00                	mov    (%rax),%eax
  800e5a:	89 c0                	mov    %eax,%eax
  800e5c:	48 01 d0             	add    %rdx,%rax
  800e5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e63:	8b 12                	mov    (%rdx),%edx
  800e65:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6c:	89 0a                	mov    %ecx,(%rdx)
  800e6e:	eb 17                	jmp    800e87 <getuint+0xb3>
  800e70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e74:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e78:	48 89 d0             	mov    %rdx,%rax
  800e7b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e83:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e87:	48 8b 00             	mov    (%rax),%rax
  800e8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e8e:	eb 4e                	jmp    800ede <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800e90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e94:	8b 00                	mov    (%rax),%eax
  800e96:	83 f8 30             	cmp    $0x30,%eax
  800e99:	73 24                	jae    800ebf <getuint+0xeb>
  800e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	8b 00                	mov    (%rax),%eax
  800ea9:	89 c0                	mov    %eax,%eax
  800eab:	48 01 d0             	add    %rdx,%rax
  800eae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb2:	8b 12                	mov    (%rdx),%edx
  800eb4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800eb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebb:	89 0a                	mov    %ecx,(%rdx)
  800ebd:	eb 17                	jmp    800ed6 <getuint+0x102>
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ec7:	48 89 d0             	mov    %rdx,%rax
  800eca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ece:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ed6:	8b 00                	mov    (%rax),%eax
  800ed8:	89 c0                	mov    %eax,%eax
  800eda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ede:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ee2:	c9                   	leaveq 
  800ee3:	c3                   	retq   

0000000000800ee4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ee4:	55                   	push   %rbp
  800ee5:	48 89 e5             	mov    %rsp,%rbp
  800ee8:	48 83 ec 20          	sub    $0x20,%rsp
  800eec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ef3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ef7:	7e 52                	jle    800f4b <getint+0x67>
		x=va_arg(*ap, long long);
  800ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efd:	8b 00                	mov    (%rax),%eax
  800eff:	83 f8 30             	cmp    $0x30,%eax
  800f02:	73 24                	jae    800f28 <getint+0x44>
  800f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f08:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f10:	8b 00                	mov    (%rax),%eax
  800f12:	89 c0                	mov    %eax,%eax
  800f14:	48 01 d0             	add    %rdx,%rax
  800f17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f1b:	8b 12                	mov    (%rdx),%edx
  800f1d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f24:	89 0a                	mov    %ecx,(%rdx)
  800f26:	eb 17                	jmp    800f3f <getint+0x5b>
  800f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f30:	48 89 d0             	mov    %rdx,%rax
  800f33:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f3b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f3f:	48 8b 00             	mov    (%rax),%rax
  800f42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f46:	e9 a3 00 00 00       	jmpq   800fee <getint+0x10a>
	else if (lflag)
  800f4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f4f:	74 4f                	je     800fa0 <getint+0xbc>
		x=va_arg(*ap, long);
  800f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f55:	8b 00                	mov    (%rax),%eax
  800f57:	83 f8 30             	cmp    $0x30,%eax
  800f5a:	73 24                	jae    800f80 <getint+0x9c>
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f60:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f68:	8b 00                	mov    (%rax),%eax
  800f6a:	89 c0                	mov    %eax,%eax
  800f6c:	48 01 d0             	add    %rdx,%rax
  800f6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f73:	8b 12                	mov    (%rdx),%edx
  800f75:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f7c:	89 0a                	mov    %ecx,(%rdx)
  800f7e:	eb 17                	jmp    800f97 <getint+0xb3>
  800f80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f84:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f88:	48 89 d0             	mov    %rdx,%rax
  800f8b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f93:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f97:	48 8b 00             	mov    (%rax),%rax
  800f9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f9e:	eb 4e                	jmp    800fee <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa4:	8b 00                	mov    (%rax),%eax
  800fa6:	83 f8 30             	cmp    $0x30,%eax
  800fa9:	73 24                	jae    800fcf <getint+0xeb>
  800fab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb7:	8b 00                	mov    (%rax),%eax
  800fb9:	89 c0                	mov    %eax,%eax
  800fbb:	48 01 d0             	add    %rdx,%rax
  800fbe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fc2:	8b 12                	mov    (%rdx),%edx
  800fc4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fc7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fcb:	89 0a                	mov    %ecx,(%rdx)
  800fcd:	eb 17                	jmp    800fe6 <getint+0x102>
  800fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fd7:	48 89 d0             	mov    %rdx,%rax
  800fda:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fde:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fe2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fe6:	8b 00                	mov    (%rax),%eax
  800fe8:	48 98                	cltq   
  800fea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ff2:	c9                   	leaveq 
  800ff3:	c3                   	retq   

0000000000800ff4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ff4:	55                   	push   %rbp
  800ff5:	48 89 e5             	mov    %rsp,%rbp
  800ff8:	41 54                	push   %r12
  800ffa:	53                   	push   %rbx
  800ffb:	48 83 ec 60          	sub    $0x60,%rsp
  800fff:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801003:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801007:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80100b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80100f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801013:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801017:	48 8b 0a             	mov    (%rdx),%rcx
  80101a:	48 89 08             	mov    %rcx,(%rax)
  80101d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801021:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801025:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801029:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80102d:	eb 17                	jmp    801046 <vprintfmt+0x52>
			if (ch == '\0')
  80102f:	85 db                	test   %ebx,%ebx
  801031:	0f 84 ea 04 00 00    	je     801521 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  801037:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80103b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80103f:	48 89 c6             	mov    %rax,%rsi
  801042:	89 df                	mov    %ebx,%edi
  801044:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801046:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80104a:	0f b6 00             	movzbl (%rax),%eax
  80104d:	0f b6 d8             	movzbl %al,%ebx
  801050:	83 fb 25             	cmp    $0x25,%ebx
  801053:	0f 95 c0             	setne  %al
  801056:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80105b:	84 c0                	test   %al,%al
  80105d:	75 d0                	jne    80102f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80105f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801063:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80106a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801071:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801078:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80107f:	eb 04                	jmp    801085 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  801081:	90                   	nop
  801082:	eb 01                	jmp    801085 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  801084:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801085:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801089:	0f b6 00             	movzbl (%rax),%eax
  80108c:	0f b6 d8             	movzbl %al,%ebx
  80108f:	89 d8                	mov    %ebx,%eax
  801091:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801096:	83 e8 23             	sub    $0x23,%eax
  801099:	83 f8 55             	cmp    $0x55,%eax
  80109c:	0f 87 4b 04 00 00    	ja     8014ed <vprintfmt+0x4f9>
  8010a2:	89 c0                	mov    %eax,%eax
  8010a4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8010ab:	00 
  8010ac:	48 b8 d8 52 80 00 00 	movabs $0x8052d8,%rax
  8010b3:	00 00 00 
  8010b6:	48 01 d0             	add    %rdx,%rax
  8010b9:	48 8b 00             	mov    (%rax),%rax
  8010bc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8010be:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8010c2:	eb c1                	jmp    801085 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8010c4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8010c8:	eb bb                	jmp    801085 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8010ca:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8010d1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8010d4:	89 d0                	mov    %edx,%eax
  8010d6:	c1 e0 02             	shl    $0x2,%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	01 c0                	add    %eax,%eax
  8010dd:	01 d8                	add    %ebx,%eax
  8010df:	83 e8 30             	sub    $0x30,%eax
  8010e2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8010e5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010e9:	0f b6 00             	movzbl (%rax),%eax
  8010ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8010ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8010f2:	7e 63                	jle    801157 <vprintfmt+0x163>
  8010f4:	83 fb 39             	cmp    $0x39,%ebx
  8010f7:	7f 5e                	jg     801157 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8010f9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8010fe:	eb d1                	jmp    8010d1 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  801100:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801103:	83 f8 30             	cmp    $0x30,%eax
  801106:	73 17                	jae    80111f <vprintfmt+0x12b>
  801108:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80110c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80110f:	89 c0                	mov    %eax,%eax
  801111:	48 01 d0             	add    %rdx,%rax
  801114:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801117:	83 c2 08             	add    $0x8,%edx
  80111a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80111d:	eb 0f                	jmp    80112e <vprintfmt+0x13a>
  80111f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801123:	48 89 d0             	mov    %rdx,%rax
  801126:	48 83 c2 08          	add    $0x8,%rdx
  80112a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80112e:	8b 00                	mov    (%rax),%eax
  801130:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801133:	eb 23                	jmp    801158 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  801135:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801139:	0f 89 42 ff ff ff    	jns    801081 <vprintfmt+0x8d>
				width = 0;
  80113f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801146:	e9 36 ff ff ff       	jmpq   801081 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  80114b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801152:	e9 2e ff ff ff       	jmpq   801085 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801157:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801158:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80115c:	0f 89 22 ff ff ff    	jns    801084 <vprintfmt+0x90>
				width = precision, precision = -1;
  801162:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801165:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801168:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80116f:	e9 10 ff ff ff       	jmpq   801084 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801174:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801178:	e9 08 ff ff ff       	jmpq   801085 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80117d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801180:	83 f8 30             	cmp    $0x30,%eax
  801183:	73 17                	jae    80119c <vprintfmt+0x1a8>
  801185:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801189:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80118c:	89 c0                	mov    %eax,%eax
  80118e:	48 01 d0             	add    %rdx,%rax
  801191:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801194:	83 c2 08             	add    $0x8,%edx
  801197:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80119a:	eb 0f                	jmp    8011ab <vprintfmt+0x1b7>
  80119c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011a0:	48 89 d0             	mov    %rdx,%rax
  8011a3:	48 83 c2 08          	add    $0x8,%rdx
  8011a7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011ab:	8b 00                	mov    (%rax),%eax
  8011ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011b1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8011b5:	48 89 d6             	mov    %rdx,%rsi
  8011b8:	89 c7                	mov    %eax,%edi
  8011ba:	ff d1                	callq  *%rcx
			break;
  8011bc:	e9 5a 03 00 00       	jmpq   80151b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8011c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011c4:	83 f8 30             	cmp    $0x30,%eax
  8011c7:	73 17                	jae    8011e0 <vprintfmt+0x1ec>
  8011c9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011d0:	89 c0                	mov    %eax,%eax
  8011d2:	48 01 d0             	add    %rdx,%rax
  8011d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011d8:	83 c2 08             	add    $0x8,%edx
  8011db:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011de:	eb 0f                	jmp    8011ef <vprintfmt+0x1fb>
  8011e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011e4:	48 89 d0             	mov    %rdx,%rax
  8011e7:	48 83 c2 08          	add    $0x8,%rdx
  8011eb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011ef:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8011f1:	85 db                	test   %ebx,%ebx
  8011f3:	79 02                	jns    8011f7 <vprintfmt+0x203>
				err = -err;
  8011f5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8011f7:	83 fb 15             	cmp    $0x15,%ebx
  8011fa:	7f 16                	jg     801212 <vprintfmt+0x21e>
  8011fc:	48 b8 00 52 80 00 00 	movabs $0x805200,%rax
  801203:	00 00 00 
  801206:	48 63 d3             	movslq %ebx,%rdx
  801209:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80120d:	4d 85 e4             	test   %r12,%r12
  801210:	75 2e                	jne    801240 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  801212:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801216:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80121a:	89 d9                	mov    %ebx,%ecx
  80121c:	48 ba c1 52 80 00 00 	movabs $0x8052c1,%rdx
  801223:	00 00 00 
  801226:	48 89 c7             	mov    %rax,%rdi
  801229:	b8 00 00 00 00       	mov    $0x0,%eax
  80122e:	49 b8 2b 15 80 00 00 	movabs $0x80152b,%r8
  801235:	00 00 00 
  801238:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80123b:	e9 db 02 00 00       	jmpq   80151b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801240:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801244:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801248:	4c 89 e1             	mov    %r12,%rcx
  80124b:	48 ba ca 52 80 00 00 	movabs $0x8052ca,%rdx
  801252:	00 00 00 
  801255:	48 89 c7             	mov    %rax,%rdi
  801258:	b8 00 00 00 00       	mov    $0x0,%eax
  80125d:	49 b8 2b 15 80 00 00 	movabs $0x80152b,%r8
  801264:	00 00 00 
  801267:	41 ff d0             	callq  *%r8
			break;
  80126a:	e9 ac 02 00 00       	jmpq   80151b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80126f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801272:	83 f8 30             	cmp    $0x30,%eax
  801275:	73 17                	jae    80128e <vprintfmt+0x29a>
  801277:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80127b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80127e:	89 c0                	mov    %eax,%eax
  801280:	48 01 d0             	add    %rdx,%rax
  801283:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801286:	83 c2 08             	add    $0x8,%edx
  801289:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80128c:	eb 0f                	jmp    80129d <vprintfmt+0x2a9>
  80128e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801292:	48 89 d0             	mov    %rdx,%rax
  801295:	48 83 c2 08          	add    $0x8,%rdx
  801299:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80129d:	4c 8b 20             	mov    (%rax),%r12
  8012a0:	4d 85 e4             	test   %r12,%r12
  8012a3:	75 0a                	jne    8012af <vprintfmt+0x2bb>
				p = "(null)";
  8012a5:	49 bc cd 52 80 00 00 	movabs $0x8052cd,%r12
  8012ac:	00 00 00 
			if (width > 0 && padc != '-')
  8012af:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8012b3:	7e 7a                	jle    80132f <vprintfmt+0x33b>
  8012b5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8012b9:	74 74                	je     80132f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012bb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8012be:	48 98                	cltq   
  8012c0:	48 89 c6             	mov    %rax,%rsi
  8012c3:	4c 89 e7             	mov    %r12,%rdi
  8012c6:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  8012cd:	00 00 00 
  8012d0:	ff d0                	callq  *%rax
  8012d2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8012d5:	eb 17                	jmp    8012ee <vprintfmt+0x2fa>
					putch(padc, putdat);
  8012d7:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8012db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012df:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8012e3:	48 89 d6             	mov    %rdx,%rsi
  8012e6:	89 c7                	mov    %eax,%edi
  8012e8:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ea:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8012ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8012f2:	7f e3                	jg     8012d7 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f4:	eb 39                	jmp    80132f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8012f6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8012fa:	74 1e                	je     80131a <vprintfmt+0x326>
  8012fc:	83 fb 1f             	cmp    $0x1f,%ebx
  8012ff:	7e 05                	jle    801306 <vprintfmt+0x312>
  801301:	83 fb 7e             	cmp    $0x7e,%ebx
  801304:	7e 14                	jle    80131a <vprintfmt+0x326>
					putch('?', putdat);
  801306:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80130a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80130e:	48 89 c6             	mov    %rax,%rsi
  801311:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801316:	ff d2                	callq  *%rdx
  801318:	eb 0f                	jmp    801329 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  80131a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80131e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801322:	48 89 c6             	mov    %rax,%rsi
  801325:	89 df                	mov    %ebx,%edi
  801327:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801329:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80132d:	eb 01                	jmp    801330 <vprintfmt+0x33c>
  80132f:	90                   	nop
  801330:	41 0f b6 04 24       	movzbl (%r12),%eax
  801335:	0f be d8             	movsbl %al,%ebx
  801338:	85 db                	test   %ebx,%ebx
  80133a:	0f 95 c0             	setne  %al
  80133d:	49 83 c4 01          	add    $0x1,%r12
  801341:	84 c0                	test   %al,%al
  801343:	74 28                	je     80136d <vprintfmt+0x379>
  801345:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801349:	78 ab                	js     8012f6 <vprintfmt+0x302>
  80134b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80134f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801353:	79 a1                	jns    8012f6 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801355:	eb 16                	jmp    80136d <vprintfmt+0x379>
				putch(' ', putdat);
  801357:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80135b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80135f:	48 89 c6             	mov    %rax,%rsi
  801362:	bf 20 00 00 00       	mov    $0x20,%edi
  801367:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801369:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80136d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801371:	7f e4                	jg     801357 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  801373:	e9 a3 01 00 00       	jmpq   80151b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801378:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80137c:	be 03 00 00 00       	mov    $0x3,%esi
  801381:	48 89 c7             	mov    %rax,%rdi
  801384:	48 b8 e4 0e 80 00 00 	movabs $0x800ee4,%rax
  80138b:	00 00 00 
  80138e:	ff d0                	callq  *%rax
  801390:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801398:	48 85 c0             	test   %rax,%rax
  80139b:	79 1d                	jns    8013ba <vprintfmt+0x3c6>
				putch('-', putdat);
  80139d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8013a1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8013a5:	48 89 c6             	mov    %rax,%rsi
  8013a8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8013ad:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8013af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b3:	48 f7 d8             	neg    %rax
  8013b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8013ba:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8013c1:	e9 e8 00 00 00       	jmpq   8014ae <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8013c6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8013ca:	be 03 00 00 00       	mov    $0x3,%esi
  8013cf:	48 89 c7             	mov    %rax,%rdi
  8013d2:	48 b8 d4 0d 80 00 00 	movabs $0x800dd4,%rax
  8013d9:	00 00 00 
  8013dc:	ff d0                	callq  *%rax
  8013de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8013e2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8013e9:	e9 c0 00 00 00       	jmpq   8014ae <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013ee:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8013f2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8013f6:	48 89 c6             	mov    %rax,%rsi
  8013f9:	bf 58 00 00 00       	mov    $0x58,%edi
  8013fe:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801400:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801404:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801408:	48 89 c6             	mov    %rax,%rsi
  80140b:	bf 58 00 00 00       	mov    $0x58,%edi
  801410:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801412:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801416:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80141a:	48 89 c6             	mov    %rax,%rsi
  80141d:	bf 58 00 00 00       	mov    $0x58,%edi
  801422:	ff d2                	callq  *%rdx
			break;
  801424:	e9 f2 00 00 00       	jmpq   80151b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  801429:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80142d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801431:	48 89 c6             	mov    %rax,%rsi
  801434:	bf 30 00 00 00       	mov    $0x30,%edi
  801439:	ff d2                	callq  *%rdx
			putch('x', putdat);
  80143b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80143f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801443:	48 89 c6             	mov    %rax,%rsi
  801446:	bf 78 00 00 00       	mov    $0x78,%edi
  80144b:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80144d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801450:	83 f8 30             	cmp    $0x30,%eax
  801453:	73 17                	jae    80146c <vprintfmt+0x478>
  801455:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801459:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80145c:	89 c0                	mov    %eax,%eax
  80145e:	48 01 d0             	add    %rdx,%rax
  801461:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801464:	83 c2 08             	add    $0x8,%edx
  801467:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80146a:	eb 0f                	jmp    80147b <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  80146c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801470:	48 89 d0             	mov    %rdx,%rax
  801473:	48 83 c2 08          	add    $0x8,%rdx
  801477:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80147b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80147e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801482:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801489:	eb 23                	jmp    8014ae <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80148b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80148f:	be 03 00 00 00       	mov    $0x3,%esi
  801494:	48 89 c7             	mov    %rax,%rdi
  801497:	48 b8 d4 0d 80 00 00 	movabs $0x800dd4,%rax
  80149e:	00 00 00 
  8014a1:	ff d0                	callq  *%rax
  8014a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8014a7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8014ae:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8014b3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8014b6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8014b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014bd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8014c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014c5:	45 89 c1             	mov    %r8d,%r9d
  8014c8:	41 89 f8             	mov    %edi,%r8d
  8014cb:	48 89 c7             	mov    %rax,%rdi
  8014ce:	48 b8 1c 0d 80 00 00 	movabs $0x800d1c,%rax
  8014d5:	00 00 00 
  8014d8:	ff d0                	callq  *%rax
			break;
  8014da:	eb 3f                	jmp    80151b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014dc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8014e0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8014e4:	48 89 c6             	mov    %rax,%rsi
  8014e7:	89 df                	mov    %ebx,%edi
  8014e9:	ff d2                	callq  *%rdx
			break;
  8014eb:	eb 2e                	jmp    80151b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ed:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8014f1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8014f5:	48 89 c6             	mov    %rax,%rsi
  8014f8:	bf 25 00 00 00       	mov    $0x25,%edi
  8014fd:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014ff:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801504:	eb 05                	jmp    80150b <vprintfmt+0x517>
  801506:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80150b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80150f:	48 83 e8 01          	sub    $0x1,%rax
  801513:	0f b6 00             	movzbl (%rax),%eax
  801516:	3c 25                	cmp    $0x25,%al
  801518:	75 ec                	jne    801506 <vprintfmt+0x512>
				/* do nothing */;
			break;
  80151a:	90                   	nop
		}
	}
  80151b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80151c:	e9 25 fb ff ff       	jmpq   801046 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801521:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801522:	48 83 c4 60          	add    $0x60,%rsp
  801526:	5b                   	pop    %rbx
  801527:	41 5c                	pop    %r12
  801529:	5d                   	pop    %rbp
  80152a:	c3                   	retq   

000000000080152b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80152b:	55                   	push   %rbp
  80152c:	48 89 e5             	mov    %rsp,%rbp
  80152f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801536:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80153d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801544:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80154b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801552:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801559:	84 c0                	test   %al,%al
  80155b:	74 20                	je     80157d <printfmt+0x52>
  80155d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801561:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801565:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801569:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80156d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801571:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801575:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801579:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80157d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801584:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80158b:	00 00 00 
  80158e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801595:	00 00 00 
  801598:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80159c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8015a3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015aa:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8015b1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8015b8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8015bf:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8015c6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8015cd:	48 89 c7             	mov    %rax,%rdi
  8015d0:	48 b8 f4 0f 80 00 00 	movabs $0x800ff4,%rax
  8015d7:	00 00 00 
  8015da:	ff d0                	callq  *%rax
	va_end(ap);
}
  8015dc:	c9                   	leaveq 
  8015dd:	c3                   	retq   

00000000008015de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015de:	55                   	push   %rbp
  8015df:	48 89 e5             	mov    %rsp,%rbp
  8015e2:	48 83 ec 10          	sub    $0x10,%rsp
  8015e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8015e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8015ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f1:	8b 40 10             	mov    0x10(%rax),%eax
  8015f4:	8d 50 01             	lea    0x1(%rax),%edx
  8015f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8015fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801602:	48 8b 10             	mov    (%rax),%rdx
  801605:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801609:	48 8b 40 08          	mov    0x8(%rax),%rax
  80160d:	48 39 c2             	cmp    %rax,%rdx
  801610:	73 17                	jae    801629 <sprintputch+0x4b>
		*b->buf++ = ch;
  801612:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801616:	48 8b 00             	mov    (%rax),%rax
  801619:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80161c:	88 10                	mov    %dl,(%rax)
  80161e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801622:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801626:	48 89 10             	mov    %rdx,(%rax)
}
  801629:	c9                   	leaveq 
  80162a:	c3                   	retq   

000000000080162b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80162b:	55                   	push   %rbp
  80162c:	48 89 e5             	mov    %rsp,%rbp
  80162f:	48 83 ec 50          	sub    $0x50,%rsp
  801633:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801637:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80163a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80163e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801642:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801646:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80164a:	48 8b 0a             	mov    (%rdx),%rcx
  80164d:	48 89 08             	mov    %rcx,(%rax)
  801650:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801654:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801658:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80165c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801660:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801664:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801668:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80166b:	48 98                	cltq   
  80166d:	48 83 e8 01          	sub    $0x1,%rax
  801671:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801675:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801679:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801680:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801685:	74 06                	je     80168d <vsnprintf+0x62>
  801687:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80168b:	7f 07                	jg     801694 <vsnprintf+0x69>
		return -E_INVAL;
  80168d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801692:	eb 2f                	jmp    8016c3 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801694:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801698:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80169c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8016a0:	48 89 c6             	mov    %rax,%rsi
  8016a3:	48 bf de 15 80 00 00 	movabs $0x8015de,%rdi
  8016aa:	00 00 00 
  8016ad:	48 b8 f4 0f 80 00 00 	movabs $0x800ff4,%rax
  8016b4:	00 00 00 
  8016b7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8016b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016bd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8016c0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8016c3:	c9                   	leaveq 
  8016c4:	c3                   	retq   

00000000008016c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016c5:	55                   	push   %rbp
  8016c6:	48 89 e5             	mov    %rsp,%rbp
  8016c9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8016d0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8016d7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8016dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8016e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8016eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8016f2:	84 c0                	test   %al,%al
  8016f4:	74 20                	je     801716 <snprintf+0x51>
  8016f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8016fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8016fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801702:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801706:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80170a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80170e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801712:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801716:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80171d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801724:	00 00 00 
  801727:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80172e:	00 00 00 
  801731:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801735:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80173c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801743:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80174a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801751:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801758:	48 8b 0a             	mov    (%rdx),%rcx
  80175b:	48 89 08             	mov    %rcx,(%rax)
  80175e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801762:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801766:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80176a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80176e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801775:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80177c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801782:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801789:	48 89 c7             	mov    %rax,%rdi
  80178c:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  801793:	00 00 00 
  801796:	ff d0                	callq  *%rax
  801798:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80179e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8017a4:	c9                   	leaveq 
  8017a5:	c3                   	retq   
	...

00000000008017a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017a8:	55                   	push   %rbp
  8017a9:	48 89 e5             	mov    %rsp,%rbp
  8017ac:	48 83 ec 18          	sub    $0x18,%rsp
  8017b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8017b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8017bb:	eb 09                	jmp    8017c6 <strlen+0x1e>
		n++;
  8017bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8017c1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	84 c0                	test   %al,%al
  8017cf:	75 ec                	jne    8017bd <strlen+0x15>
		n++;
	return n;
  8017d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8017d4:	c9                   	leaveq 
  8017d5:	c3                   	retq   

00000000008017d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017d6:	55                   	push   %rbp
  8017d7:	48 89 e5             	mov    %rsp,%rbp
  8017da:	48 83 ec 20          	sub    $0x20,%rsp
  8017de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8017ed:	eb 0e                	jmp    8017fd <strnlen+0x27>
		n++;
  8017ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017f8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8017fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801802:	74 0b                	je     80180f <strnlen+0x39>
  801804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801808:	0f b6 00             	movzbl (%rax),%eax
  80180b:	84 c0                	test   %al,%al
  80180d:	75 e0                	jne    8017ef <strnlen+0x19>
		n++;
	return n;
  80180f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801812:	c9                   	leaveq 
  801813:	c3                   	retq   

0000000000801814 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801814:	55                   	push   %rbp
  801815:	48 89 e5             	mov    %rsp,%rbp
  801818:	48 83 ec 20          	sub    $0x20,%rsp
  80181c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801820:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801828:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80182c:	90                   	nop
  80182d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801831:	0f b6 10             	movzbl (%rax),%edx
  801834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801838:	88 10                	mov    %dl,(%rax)
  80183a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183e:	0f b6 00             	movzbl (%rax),%eax
  801841:	84 c0                	test   %al,%al
  801843:	0f 95 c0             	setne  %al
  801846:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80184b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801850:	84 c0                	test   %al,%al
  801852:	75 d9                	jne    80182d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801858:	c9                   	leaveq 
  801859:	c3                   	retq   

000000000080185a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
  80185e:	48 83 ec 20          	sub    $0x20,%rsp
  801862:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801866:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80186a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80186e:	48 89 c7             	mov    %rax,%rdi
  801871:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801878:	00 00 00 
  80187b:	ff d0                	callq  *%rax
  80187d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801883:	48 98                	cltq   
  801885:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801889:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80188d:	48 89 d6             	mov    %rdx,%rsi
  801890:	48 89 c7             	mov    %rax,%rdi
  801893:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  80189a:	00 00 00 
  80189d:	ff d0                	callq  *%rax
	return dst;
  80189f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018a3:	c9                   	leaveq 
  8018a4:	c3                   	retq   

00000000008018a5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	48 83 ec 28          	sub    $0x28,%rsp
  8018ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8018b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8018c1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8018c8:	00 
  8018c9:	eb 27                	jmp    8018f2 <strncpy+0x4d>
		*dst++ = *src;
  8018cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018cf:	0f b6 10             	movzbl (%rax),%edx
  8018d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d6:	88 10                	mov    %dl,(%rax)
  8018d8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8018dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018e1:	0f b6 00             	movzbl (%rax),%eax
  8018e4:	84 c0                	test   %al,%al
  8018e6:	74 05                	je     8018ed <strncpy+0x48>
			src++;
  8018e8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8018fa:	72 cf                	jb     8018cb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8018fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801900:	c9                   	leaveq 
  801901:	c3                   	retq   

0000000000801902 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801902:	55                   	push   %rbp
  801903:	48 89 e5             	mov    %rsp,%rbp
  801906:	48 83 ec 28          	sub    $0x28,%rsp
  80190a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80190e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801912:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80191a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80191e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801923:	74 37                	je     80195c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801925:	eb 17                	jmp    80193e <strlcpy+0x3c>
			*dst++ = *src++;
  801927:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80192b:	0f b6 10             	movzbl (%rax),%edx
  80192e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801932:	88 10                	mov    %dl,(%rax)
  801934:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801939:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80193e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801943:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801948:	74 0b                	je     801955 <strlcpy+0x53>
  80194a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80194e:	0f b6 00             	movzbl (%rax),%eax
  801951:	84 c0                	test   %al,%al
  801953:	75 d2                	jne    801927 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801959:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80195c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801960:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801964:	48 89 d1             	mov    %rdx,%rcx
  801967:	48 29 c1             	sub    %rax,%rcx
  80196a:	48 89 c8             	mov    %rcx,%rax
}
  80196d:	c9                   	leaveq 
  80196e:	c3                   	retq   

000000000080196f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80196f:	55                   	push   %rbp
  801970:	48 89 e5             	mov    %rsp,%rbp
  801973:	48 83 ec 10          	sub    $0x10,%rsp
  801977:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80197b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80197f:	eb 0a                	jmp    80198b <strcmp+0x1c>
		p++, q++;
  801981:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801986:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80198b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198f:	0f b6 00             	movzbl (%rax),%eax
  801992:	84 c0                	test   %al,%al
  801994:	74 12                	je     8019a8 <strcmp+0x39>
  801996:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199a:	0f b6 10             	movzbl (%rax),%edx
  80199d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a1:	0f b6 00             	movzbl (%rax),%eax
  8019a4:	38 c2                	cmp    %al,%dl
  8019a6:	74 d9                	je     801981 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ac:	0f b6 00             	movzbl (%rax),%eax
  8019af:	0f b6 d0             	movzbl %al,%edx
  8019b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b6:	0f b6 00             	movzbl (%rax),%eax
  8019b9:	0f b6 c0             	movzbl %al,%eax
  8019bc:	89 d1                	mov    %edx,%ecx
  8019be:	29 c1                	sub    %eax,%ecx
  8019c0:	89 c8                	mov    %ecx,%eax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	48 83 ec 18          	sub    $0x18,%rsp
  8019cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8019d8:	eb 0f                	jmp    8019e9 <strncmp+0x25>
		n--, p++, q++;
  8019da:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8019df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019e4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8019e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019ee:	74 1d                	je     801a0d <strncmp+0x49>
  8019f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f4:	0f b6 00             	movzbl (%rax),%eax
  8019f7:	84 c0                	test   %al,%al
  8019f9:	74 12                	je     801a0d <strncmp+0x49>
  8019fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ff:	0f b6 10             	movzbl (%rax),%edx
  801a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a06:	0f b6 00             	movzbl (%rax),%eax
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 cd                	je     8019da <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801a0d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a12:	75 07                	jne    801a1b <strncmp+0x57>
		return 0;
  801a14:	b8 00 00 00 00       	mov    $0x0,%eax
  801a19:	eb 1a                	jmp    801a35 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a1f:	0f b6 00             	movzbl (%rax),%eax
  801a22:	0f b6 d0             	movzbl %al,%edx
  801a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a29:	0f b6 00             	movzbl (%rax),%eax
  801a2c:	0f b6 c0             	movzbl %al,%eax
  801a2f:	89 d1                	mov    %edx,%ecx
  801a31:	29 c1                	sub    %eax,%ecx
  801a33:	89 c8                	mov    %ecx,%eax
}
  801a35:	c9                   	leaveq 
  801a36:	c3                   	retq   

0000000000801a37 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a37:	55                   	push   %rbp
  801a38:	48 89 e5             	mov    %rsp,%rbp
  801a3b:	48 83 ec 10          	sub    $0x10,%rsp
  801a3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a43:	89 f0                	mov    %esi,%eax
  801a45:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801a48:	eb 17                	jmp    801a61 <strchr+0x2a>
		if (*s == c)
  801a4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4e:	0f b6 00             	movzbl (%rax),%eax
  801a51:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801a54:	75 06                	jne    801a5c <strchr+0x25>
			return (char *) s;
  801a56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5a:	eb 15                	jmp    801a71 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a5c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a65:	0f b6 00             	movzbl (%rax),%eax
  801a68:	84 c0                	test   %al,%al
  801a6a:	75 de                	jne    801a4a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a71:	c9                   	leaveq 
  801a72:	c3                   	retq   

0000000000801a73 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a73:	55                   	push   %rbp
  801a74:	48 89 e5             	mov    %rsp,%rbp
  801a77:	48 83 ec 10          	sub    $0x10,%rsp
  801a7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a7f:	89 f0                	mov    %esi,%eax
  801a81:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801a84:	eb 11                	jmp    801a97 <strfind+0x24>
		if (*s == c)
  801a86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8a:	0f b6 00             	movzbl (%rax),%eax
  801a8d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801a90:	74 12                	je     801aa4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a92:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9b:	0f b6 00             	movzbl (%rax),%eax
  801a9e:	84 c0                	test   %al,%al
  801aa0:	75 e4                	jne    801a86 <strfind+0x13>
  801aa2:	eb 01                	jmp    801aa5 <strfind+0x32>
		if (*s == c)
			break;
  801aa4:	90                   	nop
	return (char *) s;
  801aa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801aa9:	c9                   	leaveq 
  801aaa:	c3                   	retq   

0000000000801aab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801aab:	55                   	push   %rbp
  801aac:	48 89 e5             	mov    %rsp,%rbp
  801aaf:	48 83 ec 18          	sub    $0x18,%rsp
  801ab3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ab7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801aba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801abe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ac3:	75 06                	jne    801acb <memset+0x20>
		return v;
  801ac5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac9:	eb 69                	jmp    801b34 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801acb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801acf:	83 e0 03             	and    $0x3,%eax
  801ad2:	48 85 c0             	test   %rax,%rax
  801ad5:	75 48                	jne    801b1f <memset+0x74>
  801ad7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801adb:	83 e0 03             	and    $0x3,%eax
  801ade:	48 85 c0             	test   %rax,%rax
  801ae1:	75 3c                	jne    801b1f <memset+0x74>
		c &= 0xFF;
  801ae3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801aea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801aed:	89 c2                	mov    %eax,%edx
  801aef:	c1 e2 18             	shl    $0x18,%edx
  801af2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801af5:	c1 e0 10             	shl    $0x10,%eax
  801af8:	09 c2                	or     %eax,%edx
  801afa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801afd:	c1 e0 08             	shl    $0x8,%eax
  801b00:	09 d0                	or     %edx,%eax
  801b02:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b09:	48 89 c1             	mov    %rax,%rcx
  801b0c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b10:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b17:	48 89 d7             	mov    %rdx,%rdi
  801b1a:	fc                   	cld    
  801b1b:	f3 ab                	rep stos %eax,%es:(%rdi)
  801b1d:	eb 11                	jmp    801b30 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b23:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b2a:	48 89 d7             	mov    %rdx,%rdi
  801b2d:	fc                   	cld    
  801b2e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801b30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b34:	c9                   	leaveq 
  801b35:	c3                   	retq   

0000000000801b36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b36:	55                   	push   %rbp
  801b37:	48 89 e5             	mov    %rsp,%rbp
  801b3a:	48 83 ec 28          	sub    $0x28,%rsp
  801b3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b46:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801b4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b56:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801b62:	0f 83 88 00 00 00    	jae    801bf0 <memmove+0xba>
  801b68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b70:	48 01 d0             	add    %rdx,%rax
  801b73:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801b77:	76 77                	jbe    801bf0 <memmove+0xba>
		s += n;
  801b79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b7d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801b81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b85:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b8d:	83 e0 03             	and    $0x3,%eax
  801b90:	48 85 c0             	test   %rax,%rax
  801b93:	75 3b                	jne    801bd0 <memmove+0x9a>
  801b95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b99:	83 e0 03             	and    $0x3,%eax
  801b9c:	48 85 c0             	test   %rax,%rax
  801b9f:	75 2f                	jne    801bd0 <memmove+0x9a>
  801ba1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba5:	83 e0 03             	and    $0x3,%eax
  801ba8:	48 85 c0             	test   %rax,%rax
  801bab:	75 23                	jne    801bd0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801bad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb1:	48 83 e8 04          	sub    $0x4,%rax
  801bb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bb9:	48 83 ea 04          	sub    $0x4,%rdx
  801bbd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801bc1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801bc5:	48 89 c7             	mov    %rax,%rdi
  801bc8:	48 89 d6             	mov    %rdx,%rsi
  801bcb:	fd                   	std    
  801bcc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801bce:	eb 1d                	jmp    801bed <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801bd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801bd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bdc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801be0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be4:	48 89 d7             	mov    %rdx,%rdi
  801be7:	48 89 c1             	mov    %rax,%rcx
  801bea:	fd                   	std    
  801beb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801bed:	fc                   	cld    
  801bee:	eb 57                	jmp    801c47 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf4:	83 e0 03             	and    $0x3,%eax
  801bf7:	48 85 c0             	test   %rax,%rax
  801bfa:	75 36                	jne    801c32 <memmove+0xfc>
  801bfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c00:	83 e0 03             	and    $0x3,%eax
  801c03:	48 85 c0             	test   %rax,%rax
  801c06:	75 2a                	jne    801c32 <memmove+0xfc>
  801c08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c0c:	83 e0 03             	and    $0x3,%eax
  801c0f:	48 85 c0             	test   %rax,%rax
  801c12:	75 1e                	jne    801c32 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801c14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c18:	48 89 c1             	mov    %rax,%rcx
  801c1b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c23:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c27:	48 89 c7             	mov    %rax,%rdi
  801c2a:	48 89 d6             	mov    %rdx,%rsi
  801c2d:	fc                   	cld    
  801c2e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c30:	eb 15                	jmp    801c47 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801c32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c36:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c3a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c3e:	48 89 c7             	mov    %rax,%rdi
  801c41:	48 89 d6             	mov    %rdx,%rsi
  801c44:	fc                   	cld    
  801c45:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801c47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c4b:	c9                   	leaveq 
  801c4c:	c3                   	retq   

0000000000801c4d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801c4d:	55                   	push   %rbp
  801c4e:	48 89 e5             	mov    %rsp,%rbp
  801c51:	48 83 ec 18          	sub    $0x18,%rsp
  801c55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c5d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801c61:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c65:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6d:	48 89 ce             	mov    %rcx,%rsi
  801c70:	48 89 c7             	mov    %rax,%rdi
  801c73:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
}
  801c7f:	c9                   	leaveq 
  801c80:	c3                   	retq   

0000000000801c81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	48 83 ec 28          	sub    $0x28,%rsp
  801c89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c91:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c99:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801c9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ca1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801ca5:	eb 38                	jmp    801cdf <memcmp+0x5e>
		if (*s1 != *s2)
  801ca7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cab:	0f b6 10             	movzbl (%rax),%edx
  801cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb2:	0f b6 00             	movzbl (%rax),%eax
  801cb5:	38 c2                	cmp    %al,%dl
  801cb7:	74 1c                	je     801cd5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbd:	0f b6 00             	movzbl (%rax),%eax
  801cc0:	0f b6 d0             	movzbl %al,%edx
  801cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc7:	0f b6 00             	movzbl (%rax),%eax
  801cca:	0f b6 c0             	movzbl %al,%eax
  801ccd:	89 d1                	mov    %edx,%ecx
  801ccf:	29 c1                	sub    %eax,%ecx
  801cd1:	89 c8                	mov    %ecx,%eax
  801cd3:	eb 20                	jmp    801cf5 <memcmp+0x74>
		s1++, s2++;
  801cd5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801cda:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801cdf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ce4:	0f 95 c0             	setne  %al
  801ce7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801cec:	84 c0                	test   %al,%al
  801cee:	75 b7                	jne    801ca7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf5:	c9                   	leaveq 
  801cf6:	c3                   	retq   

0000000000801cf7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801cf7:	55                   	push   %rbp
  801cf8:	48 89 e5             	mov    %rsp,%rbp
  801cfb:	48 83 ec 28          	sub    $0x28,%rsp
  801cff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d03:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801d06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801d0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d12:	48 01 d0             	add    %rdx,%rax
  801d15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801d19:	eb 13                	jmp    801d2e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801d1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1f:	0f b6 10             	movzbl (%rax),%edx
  801d22:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d25:	38 c2                	cmp    %al,%dl
  801d27:	74 11                	je     801d3a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801d29:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d32:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801d36:	72 e3                	jb     801d1b <memfind+0x24>
  801d38:	eb 01                	jmp    801d3b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801d3a:	90                   	nop
	return (void *) s;
  801d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d3f:	c9                   	leaveq 
  801d40:	c3                   	retq   

0000000000801d41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801d41:	55                   	push   %rbp
  801d42:	48 89 e5             	mov    %rsp,%rbp
  801d45:	48 83 ec 38          	sub    $0x38,%rsp
  801d49:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d4d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801d51:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801d54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801d5b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801d62:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d63:	eb 05                	jmp    801d6a <strtol+0x29>
		s++;
  801d65:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d6e:	0f b6 00             	movzbl (%rax),%eax
  801d71:	3c 20                	cmp    $0x20,%al
  801d73:	74 f0                	je     801d65 <strtol+0x24>
  801d75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d79:	0f b6 00             	movzbl (%rax),%eax
  801d7c:	3c 09                	cmp    $0x9,%al
  801d7e:	74 e5                	je     801d65 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d84:	0f b6 00             	movzbl (%rax),%eax
  801d87:	3c 2b                	cmp    $0x2b,%al
  801d89:	75 07                	jne    801d92 <strtol+0x51>
		s++;
  801d8b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d90:	eb 17                	jmp    801da9 <strtol+0x68>
	else if (*s == '-')
  801d92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d96:	0f b6 00             	movzbl (%rax),%eax
  801d99:	3c 2d                	cmp    $0x2d,%al
  801d9b:	75 0c                	jne    801da9 <strtol+0x68>
		s++, neg = 1;
  801d9d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801da9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801dad:	74 06                	je     801db5 <strtol+0x74>
  801daf:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801db3:	75 28                	jne    801ddd <strtol+0x9c>
  801db5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db9:	0f b6 00             	movzbl (%rax),%eax
  801dbc:	3c 30                	cmp    $0x30,%al
  801dbe:	75 1d                	jne    801ddd <strtol+0x9c>
  801dc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc4:	48 83 c0 01          	add    $0x1,%rax
  801dc8:	0f b6 00             	movzbl (%rax),%eax
  801dcb:	3c 78                	cmp    $0x78,%al
  801dcd:	75 0e                	jne    801ddd <strtol+0x9c>
		s += 2, base = 16;
  801dcf:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801dd4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801ddb:	eb 2c                	jmp    801e09 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801ddd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801de1:	75 19                	jne    801dfc <strtol+0xbb>
  801de3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de7:	0f b6 00             	movzbl (%rax),%eax
  801dea:	3c 30                	cmp    $0x30,%al
  801dec:	75 0e                	jne    801dfc <strtol+0xbb>
		s++, base = 8;
  801dee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801df3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801dfa:	eb 0d                	jmp    801e09 <strtol+0xc8>
	else if (base == 0)
  801dfc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e00:	75 07                	jne    801e09 <strtol+0xc8>
		base = 10;
  801e02:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801e09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0d:	0f b6 00             	movzbl (%rax),%eax
  801e10:	3c 2f                	cmp    $0x2f,%al
  801e12:	7e 1d                	jle    801e31 <strtol+0xf0>
  801e14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e18:	0f b6 00             	movzbl (%rax),%eax
  801e1b:	3c 39                	cmp    $0x39,%al
  801e1d:	7f 12                	jg     801e31 <strtol+0xf0>
			dig = *s - '0';
  801e1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e23:	0f b6 00             	movzbl (%rax),%eax
  801e26:	0f be c0             	movsbl %al,%eax
  801e29:	83 e8 30             	sub    $0x30,%eax
  801e2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e2f:	eb 4e                	jmp    801e7f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801e31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e35:	0f b6 00             	movzbl (%rax),%eax
  801e38:	3c 60                	cmp    $0x60,%al
  801e3a:	7e 1d                	jle    801e59 <strtol+0x118>
  801e3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e40:	0f b6 00             	movzbl (%rax),%eax
  801e43:	3c 7a                	cmp    $0x7a,%al
  801e45:	7f 12                	jg     801e59 <strtol+0x118>
			dig = *s - 'a' + 10;
  801e47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4b:	0f b6 00             	movzbl (%rax),%eax
  801e4e:	0f be c0             	movsbl %al,%eax
  801e51:	83 e8 57             	sub    $0x57,%eax
  801e54:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e57:	eb 26                	jmp    801e7f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801e59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5d:	0f b6 00             	movzbl (%rax),%eax
  801e60:	3c 40                	cmp    $0x40,%al
  801e62:	7e 47                	jle    801eab <strtol+0x16a>
  801e64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e68:	0f b6 00             	movzbl (%rax),%eax
  801e6b:	3c 5a                	cmp    $0x5a,%al
  801e6d:	7f 3c                	jg     801eab <strtol+0x16a>
			dig = *s - 'A' + 10;
  801e6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e73:	0f b6 00             	movzbl (%rax),%eax
  801e76:	0f be c0             	movsbl %al,%eax
  801e79:	83 e8 37             	sub    $0x37,%eax
  801e7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801e7f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e82:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801e85:	7d 23                	jge    801eaa <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801e87:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e8c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e8f:	48 98                	cltq   
  801e91:	48 89 c2             	mov    %rax,%rdx
  801e94:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801e99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e9c:	48 98                	cltq   
  801e9e:	48 01 d0             	add    %rdx,%rax
  801ea1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ea5:	e9 5f ff ff ff       	jmpq   801e09 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801eaa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801eab:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801eb0:	74 0b                	je     801ebd <strtol+0x17c>
		*endptr = (char *) s;
  801eb2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801eb6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801eba:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ebd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec1:	74 09                	je     801ecc <strtol+0x18b>
  801ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec7:	48 f7 d8             	neg    %rax
  801eca:	eb 04                	jmp    801ed0 <strtol+0x18f>
  801ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ed0:	c9                   	leaveq 
  801ed1:	c3                   	retq   

0000000000801ed2 <strstr>:

char * strstr(const char *in, const char *str)
{
  801ed2:	55                   	push   %rbp
  801ed3:	48 89 e5             	mov    %rsp,%rbp
  801ed6:	48 83 ec 30          	sub    $0x30,%rsp
  801eda:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ede:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801ee2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ee6:	0f b6 00             	movzbl (%rax),%eax
  801ee9:	88 45 ff             	mov    %al,-0x1(%rbp)
  801eec:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801ef1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ef5:	75 06                	jne    801efd <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801ef7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efb:	eb 68                	jmp    801f65 <strstr+0x93>

	len = strlen(str);
  801efd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f01:	48 89 c7             	mov    %rax,%rdi
  801f04:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  801f0b:	00 00 00 
  801f0e:	ff d0                	callq  *%rax
  801f10:	48 98                	cltq   
  801f12:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801f16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1a:	0f b6 00             	movzbl (%rax),%eax
  801f1d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801f20:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801f25:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801f29:	75 07                	jne    801f32 <strstr+0x60>
				return (char *) 0;
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f30:	eb 33                	jmp    801f65 <strstr+0x93>
		} while (sc != c);
  801f32:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801f36:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801f39:	75 db                	jne    801f16 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801f3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801f43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f47:	48 89 ce             	mov    %rcx,%rsi
  801f4a:	48 89 c7             	mov    %rax,%rdi
  801f4d:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  801f54:	00 00 00 
  801f57:	ff d0                	callq  *%rax
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	75 b9                	jne    801f16 <strstr+0x44>

	return (char *) (in - 1);
  801f5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f61:	48 83 e8 01          	sub    $0x1,%rax
}
  801f65:	c9                   	leaveq 
  801f66:	c3                   	retq   
	...

0000000000801f68 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801f68:	55                   	push   %rbp
  801f69:	48 89 e5             	mov    %rsp,%rbp
  801f6c:	53                   	push   %rbx
  801f6d:	48 83 ec 58          	sub    $0x58,%rsp
  801f71:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f74:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801f77:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801f7b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801f7f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801f83:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f87:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f8a:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801f8d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801f91:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801f95:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801f99:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801f9d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801fa1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801fa4:	4c 89 c3             	mov    %r8,%rbx
  801fa7:	cd 30                	int    $0x30
  801fa9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801fad:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801fb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801fb5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801fb9:	74 3e                	je     801ff9 <syscall+0x91>
  801fbb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801fc0:	7e 37                	jle    801ff9 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801fc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fc6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801fc9:	49 89 d0             	mov    %rdx,%r8
  801fcc:	89 c1                	mov    %eax,%ecx
  801fce:	48 ba 88 55 80 00 00 	movabs $0x805588,%rdx
  801fd5:	00 00 00 
  801fd8:	be 23 00 00 00       	mov    $0x23,%esi
  801fdd:	48 bf a5 55 80 00 00 	movabs $0x8055a5,%rdi
  801fe4:	00 00 00 
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	49 b9 08 0a 80 00 00 	movabs $0x800a08,%r9
  801ff3:	00 00 00 
  801ff6:	41 ff d1             	callq  *%r9

	return ret;
  801ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ffd:	48 83 c4 58          	add    $0x58,%rsp
  802001:	5b                   	pop    %rbx
  802002:	5d                   	pop    %rbp
  802003:	c3                   	retq   

0000000000802004 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802004:	55                   	push   %rbp
  802005:	48 89 e5             	mov    %rsp,%rbp
  802008:	48 83 ec 20          	sub    $0x20,%rsp
  80200c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802010:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802014:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802018:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802023:	00 
  802024:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80202a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802030:	48 89 d1             	mov    %rdx,%rcx
  802033:	48 89 c2             	mov    %rax,%rdx
  802036:	be 00 00 00 00       	mov    $0x0,%esi
  80203b:	bf 00 00 00 00       	mov    $0x0,%edi
  802040:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  802047:	00 00 00 
  80204a:	ff d0                	callq  *%rax
}
  80204c:	c9                   	leaveq 
  80204d:	c3                   	retq   

000000000080204e <sys_cgetc>:

int
sys_cgetc(void)
{
  80204e:	55                   	push   %rbp
  80204f:	48 89 e5             	mov    %rsp,%rbp
  802052:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802056:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80205d:	00 
  80205e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802064:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80206a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80206f:	ba 00 00 00 00       	mov    $0x0,%edx
  802074:	be 00 00 00 00       	mov    $0x0,%esi
  802079:	bf 01 00 00 00       	mov    $0x1,%edi
  80207e:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  802085:	00 00 00 
  802088:	ff d0                	callq  *%rax
}
  80208a:	c9                   	leaveq 
  80208b:	c3                   	retq   

000000000080208c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80208c:	55                   	push   %rbp
  80208d:	48 89 e5             	mov    %rsp,%rbp
  802090:	48 83 ec 20          	sub    $0x20,%rsp
  802094:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209a:	48 98                	cltq   
  80209c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020a3:	00 
  8020a4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020b5:	48 89 c2             	mov    %rax,%rdx
  8020b8:	be 01 00 00 00       	mov    $0x1,%esi
  8020bd:	bf 03 00 00 00       	mov    $0x3,%edi
  8020c2:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax
}
  8020ce:	c9                   	leaveq 
  8020cf:	c3                   	retq   

00000000008020d0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8020d0:	55                   	push   %rbp
  8020d1:	48 89 e5             	mov    %rsp,%rbp
  8020d4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8020d8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020df:	00 
  8020e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f6:	be 00 00 00 00       	mov    $0x0,%esi
  8020fb:	bf 02 00 00 00       	mov    $0x2,%edi
  802100:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  802107:	00 00 00 
  80210a:	ff d0                	callq  *%rax
}
  80210c:	c9                   	leaveq 
  80210d:	c3                   	retq   

000000000080210e <sys_yield>:

void
sys_yield(void)
{
  80210e:	55                   	push   %rbp
  80210f:	48 89 e5             	mov    %rsp,%rbp
  802112:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802116:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80211d:	00 
  80211e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802124:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80212a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80212f:	ba 00 00 00 00       	mov    $0x0,%edx
  802134:	be 00 00 00 00       	mov    $0x0,%esi
  802139:	bf 0b 00 00 00       	mov    $0xb,%edi
  80213e:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  802145:	00 00 00 
  802148:	ff d0                	callq  *%rax
}
  80214a:	c9                   	leaveq 
  80214b:	c3                   	retq   

000000000080214c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80214c:	55                   	push   %rbp
  80214d:	48 89 e5             	mov    %rsp,%rbp
  802150:	48 83 ec 20          	sub    $0x20,%rsp
  802154:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802157:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80215b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80215e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802161:	48 63 c8             	movslq %eax,%rcx
  802164:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802168:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216b:	48 98                	cltq   
  80216d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802174:	00 
  802175:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80217b:	49 89 c8             	mov    %rcx,%r8
  80217e:	48 89 d1             	mov    %rdx,%rcx
  802181:	48 89 c2             	mov    %rax,%rdx
  802184:	be 01 00 00 00       	mov    $0x1,%esi
  802189:	bf 04 00 00 00       	mov    $0x4,%edi
  80218e:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  802195:	00 00 00 
  802198:	ff d0                	callq  *%rax
}
  80219a:	c9                   	leaveq 
  80219b:	c3                   	retq   

000000000080219c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80219c:	55                   	push   %rbp
  80219d:	48 89 e5             	mov    %rsp,%rbp
  8021a0:	48 83 ec 30          	sub    $0x30,%rsp
  8021a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021ab:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8021ae:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8021b2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8021b6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8021b9:	48 63 c8             	movslq %eax,%rcx
  8021bc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8021c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021c3:	48 63 f0             	movslq %eax,%rsi
  8021c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cd:	48 98                	cltq   
  8021cf:	48 89 0c 24          	mov    %rcx,(%rsp)
  8021d3:	49 89 f9             	mov    %rdi,%r9
  8021d6:	49 89 f0             	mov    %rsi,%r8
  8021d9:	48 89 d1             	mov    %rdx,%rcx
  8021dc:	48 89 c2             	mov    %rax,%rdx
  8021df:	be 01 00 00 00       	mov    $0x1,%esi
  8021e4:	bf 05 00 00 00       	mov    $0x5,%edi
  8021e9:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	callq  *%rax
}
  8021f5:	c9                   	leaveq 
  8021f6:	c3                   	retq   

00000000008021f7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8021f7:	55                   	push   %rbp
  8021f8:	48 89 e5             	mov    %rsp,%rbp
  8021fb:	48 83 ec 20          	sub    $0x20,%rsp
  8021ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802206:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80220a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220d:	48 98                	cltq   
  80220f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802216:	00 
  802217:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80221d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802223:	48 89 d1             	mov    %rdx,%rcx
  802226:	48 89 c2             	mov    %rax,%rdx
  802229:	be 01 00 00 00       	mov    $0x1,%esi
  80222e:	bf 06 00 00 00       	mov    $0x6,%edi
  802233:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  80223a:	00 00 00 
  80223d:	ff d0                	callq  *%rax
}
  80223f:	c9                   	leaveq 
  802240:	c3                   	retq   

0000000000802241 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802241:	55                   	push   %rbp
  802242:	48 89 e5             	mov    %rsp,%rbp
  802245:	48 83 ec 20          	sub    $0x20,%rsp
  802249:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80224c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80224f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802252:	48 63 d0             	movslq %eax,%rdx
  802255:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802258:	48 98                	cltq   
  80225a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802261:	00 
  802262:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802268:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80226e:	48 89 d1             	mov    %rdx,%rcx
  802271:	48 89 c2             	mov    %rax,%rdx
  802274:	be 01 00 00 00       	mov    $0x1,%esi
  802279:	bf 08 00 00 00       	mov    $0x8,%edi
  80227e:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  802285:	00 00 00 
  802288:	ff d0                	callq  *%rax
}
  80228a:	c9                   	leaveq 
  80228b:	c3                   	retq   

000000000080228c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80228c:	55                   	push   %rbp
  80228d:	48 89 e5             	mov    %rsp,%rbp
  802290:	48 83 ec 20          	sub    $0x20,%rsp
  802294:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802297:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80229b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80229f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a2:	48 98                	cltq   
  8022a4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022ab:	00 
  8022ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022b8:	48 89 d1             	mov    %rdx,%rcx
  8022bb:	48 89 c2             	mov    %rax,%rdx
  8022be:	be 01 00 00 00       	mov    $0x1,%esi
  8022c3:	bf 09 00 00 00       	mov    $0x9,%edi
  8022c8:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8022cf:	00 00 00 
  8022d2:	ff d0                	callq  *%rax
}
  8022d4:	c9                   	leaveq 
  8022d5:	c3                   	retq   

00000000008022d6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8022d6:	55                   	push   %rbp
  8022d7:	48 89 e5             	mov    %rsp,%rbp
  8022da:	48 83 ec 20          	sub    $0x20,%rsp
  8022de:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8022e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ec:	48 98                	cltq   
  8022ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022f5:	00 
  8022f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802302:	48 89 d1             	mov    %rdx,%rcx
  802305:	48 89 c2             	mov    %rax,%rdx
  802308:	be 01 00 00 00       	mov    $0x1,%esi
  80230d:	bf 0a 00 00 00       	mov    $0xa,%edi
  802312:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  802319:	00 00 00 
  80231c:	ff d0                	callq  *%rax
}
  80231e:	c9                   	leaveq 
  80231f:	c3                   	retq   

0000000000802320 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802320:	55                   	push   %rbp
  802321:	48 89 e5             	mov    %rsp,%rbp
  802324:	48 83 ec 30          	sub    $0x30,%rsp
  802328:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80232b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80232f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802333:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802336:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802339:	48 63 f0             	movslq %eax,%rsi
  80233c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802343:	48 98                	cltq   
  802345:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802349:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802350:	00 
  802351:	49 89 f1             	mov    %rsi,%r9
  802354:	49 89 c8             	mov    %rcx,%r8
  802357:	48 89 d1             	mov    %rdx,%rcx
  80235a:	48 89 c2             	mov    %rax,%rdx
  80235d:	be 00 00 00 00       	mov    $0x0,%esi
  802362:	bf 0c 00 00 00       	mov    $0xc,%edi
  802367:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  80236e:	00 00 00 
  802371:	ff d0                	callq  *%rax
}
  802373:	c9                   	leaveq 
  802374:	c3                   	retq   

0000000000802375 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802375:	55                   	push   %rbp
  802376:	48 89 e5             	mov    %rsp,%rbp
  802379:	48 83 ec 20          	sub    $0x20,%rsp
  80237d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802385:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80238c:	00 
  80238d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802393:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802399:	b9 00 00 00 00       	mov    $0x0,%ecx
  80239e:	48 89 c2             	mov    %rax,%rdx
  8023a1:	be 01 00 00 00       	mov    $0x1,%esi
  8023a6:	bf 0d 00 00 00       	mov    $0xd,%edi
  8023ab:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8023b2:	00 00 00 
  8023b5:	ff d0                	callq  *%rax
}
  8023b7:	c9                   	leaveq 
  8023b8:	c3                   	retq   

00000000008023b9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8023b9:	55                   	push   %rbp
  8023ba:	48 89 e5             	mov    %rsp,%rbp
  8023bd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8023c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023c8:	00 
  8023c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023da:	ba 00 00 00 00       	mov    $0x0,%edx
  8023df:	be 00 00 00 00       	mov    $0x0,%esi
  8023e4:	bf 0e 00 00 00       	mov    $0xe,%edi
  8023e9:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8023f0:	00 00 00 
  8023f3:	ff d0                	callq  *%rax
}
  8023f5:	c9                   	leaveq 
  8023f6:	c3                   	retq   

00000000008023f7 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8023f7:	55                   	push   %rbp
  8023f8:	48 89 e5             	mov    %rsp,%rbp
  8023fb:	48 83 ec 30          	sub    $0x30,%rsp
  8023ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802402:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802406:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802409:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80240d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802411:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802414:	48 63 c8             	movslq %eax,%rcx
  802417:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80241b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80241e:	48 63 f0             	movslq %eax,%rsi
  802421:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802425:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802428:	48 98                	cltq   
  80242a:	48 89 0c 24          	mov    %rcx,(%rsp)
  80242e:	49 89 f9             	mov    %rdi,%r9
  802431:	49 89 f0             	mov    %rsi,%r8
  802434:	48 89 d1             	mov    %rdx,%rcx
  802437:	48 89 c2             	mov    %rax,%rdx
  80243a:	be 00 00 00 00       	mov    $0x0,%esi
  80243f:	bf 0f 00 00 00       	mov    $0xf,%edi
  802444:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  80244b:	00 00 00 
  80244e:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802450:	c9                   	leaveq 
  802451:	c3                   	retq   

0000000000802452 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802452:	55                   	push   %rbp
  802453:	48 89 e5             	mov    %rsp,%rbp
  802456:	48 83 ec 20          	sub    $0x20,%rsp
  80245a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80245e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802462:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802471:	00 
  802472:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802478:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80247e:	48 89 d1             	mov    %rdx,%rcx
  802481:	48 89 c2             	mov    %rax,%rdx
  802484:	be 00 00 00 00       	mov    $0x0,%esi
  802489:	bf 10 00 00 00       	mov    $0x10,%edi
  80248e:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
}
  80249a:	c9                   	leaveq 
  80249b:	c3                   	retq   

000000000080249c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80249c:	55                   	push   %rbp
  80249d:	48 89 e5             	mov    %rsp,%rbp
  8024a0:	48 83 ec 08          	sub    $0x8,%rsp
  8024a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024b3:	ff ff ff 
  8024b6:	48 01 d0             	add    %rdx,%rax
  8024b9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024bd:	c9                   	leaveq 
  8024be:	c3                   	retq   

00000000008024bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024bf:	55                   	push   %rbp
  8024c0:	48 89 e5             	mov    %rsp,%rbp
  8024c3:	48 83 ec 08          	sub    $0x8,%rsp
  8024c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024cf:	48 89 c7             	mov    %rax,%rdi
  8024d2:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	callq  *%rax
  8024de:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024e4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024e8:	c9                   	leaveq 
  8024e9:	c3                   	retq   

00000000008024ea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024ea:	55                   	push   %rbp
  8024eb:	48 89 e5             	mov    %rsp,%rbp
  8024ee:	48 83 ec 18          	sub    $0x18,%rsp
  8024f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024fd:	eb 6b                	jmp    80256a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802502:	48 98                	cltq   
  802504:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80250a:	48 c1 e0 0c          	shl    $0xc,%rax
  80250e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802516:	48 89 c2             	mov    %rax,%rdx
  802519:	48 c1 ea 15          	shr    $0x15,%rdx
  80251d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802524:	01 00 00 
  802527:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252b:	83 e0 01             	and    $0x1,%eax
  80252e:	48 85 c0             	test   %rax,%rax
  802531:	74 21                	je     802554 <fd_alloc+0x6a>
  802533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802537:	48 89 c2             	mov    %rax,%rdx
  80253a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80253e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802545:	01 00 00 
  802548:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80254c:	83 e0 01             	and    $0x1,%eax
  80254f:	48 85 c0             	test   %rax,%rax
  802552:	75 12                	jne    802566 <fd_alloc+0x7c>
			*fd_store = fd;
  802554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802558:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80255c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80255f:	b8 00 00 00 00       	mov    $0x0,%eax
  802564:	eb 1a                	jmp    802580 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802566:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80256a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80256e:	7e 8f                	jle    8024ff <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802574:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80257b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802580:	c9                   	leaveq 
  802581:	c3                   	retq   

0000000000802582 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802582:	55                   	push   %rbp
  802583:	48 89 e5             	mov    %rsp,%rbp
  802586:	48 83 ec 20          	sub    $0x20,%rsp
  80258a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80258d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802591:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802595:	78 06                	js     80259d <fd_lookup+0x1b>
  802597:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80259b:	7e 07                	jle    8025a4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80259d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025a2:	eb 6c                	jmp    802610 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025a7:	48 98                	cltq   
  8025a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025af:	48 c1 e0 0c          	shl    $0xc,%rax
  8025b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025bb:	48 89 c2             	mov    %rax,%rdx
  8025be:	48 c1 ea 15          	shr    $0x15,%rdx
  8025c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025c9:	01 00 00 
  8025cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d0:	83 e0 01             	and    $0x1,%eax
  8025d3:	48 85 c0             	test   %rax,%rax
  8025d6:	74 21                	je     8025f9 <fd_lookup+0x77>
  8025d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025dc:	48 89 c2             	mov    %rax,%rdx
  8025df:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ea:	01 00 00 
  8025ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f1:	83 e0 01             	and    $0x1,%eax
  8025f4:	48 85 c0             	test   %rax,%rax
  8025f7:	75 07                	jne    802600 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025fe:	eb 10                	jmp    802610 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802604:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802608:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80260b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802610:	c9                   	leaveq 
  802611:	c3                   	retq   

0000000000802612 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802612:	55                   	push   %rbp
  802613:	48 89 e5             	mov    %rsp,%rbp
  802616:	48 83 ec 30          	sub    $0x30,%rsp
  80261a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80261e:	89 f0                	mov    %esi,%eax
  802620:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802627:	48 89 c7             	mov    %rax,%rdi
  80262a:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  802631:	00 00 00 
  802634:	ff d0                	callq  *%rax
  802636:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80263a:	48 89 d6             	mov    %rdx,%rsi
  80263d:	89 c7                	mov    %eax,%edi
  80263f:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  802646:	00 00 00 
  802649:	ff d0                	callq  *%rax
  80264b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802652:	78 0a                	js     80265e <fd_close+0x4c>
	    || fd != fd2)
  802654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802658:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80265c:	74 12                	je     802670 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80265e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802662:	74 05                	je     802669 <fd_close+0x57>
  802664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802667:	eb 05                	jmp    80266e <fd_close+0x5c>
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
  80266e:	eb 69                	jmp    8026d9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802674:	8b 00                	mov    (%rax),%eax
  802676:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80267a:	48 89 d6             	mov    %rdx,%rsi
  80267d:	89 c7                	mov    %eax,%edi
  80267f:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
  80268b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802692:	78 2a                	js     8026be <fd_close+0xac>
		if (dev->dev_close)
  802694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802698:	48 8b 40 20          	mov    0x20(%rax),%rax
  80269c:	48 85 c0             	test   %rax,%rax
  80269f:	74 16                	je     8026b7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8026a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ad:	48 89 c7             	mov    %rax,%rdi
  8026b0:	ff d2                	callq  *%rdx
  8026b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b5:	eb 07                	jmp    8026be <fd_close+0xac>
		else
			r = 0;
  8026b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c2:	48 89 c6             	mov    %rax,%rsi
  8026c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ca:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  8026d1:	00 00 00 
  8026d4:	ff d0                	callq  *%rax
	return r;
  8026d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026d9:	c9                   	leaveq 
  8026da:	c3                   	retq   

00000000008026db <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026db:	55                   	push   %rbp
  8026dc:	48 89 e5             	mov    %rsp,%rbp
  8026df:	48 83 ec 20          	sub    $0x20,%rsp
  8026e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026f1:	eb 41                	jmp    802734 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026f3:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8026fa:	00 00 00 
  8026fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802700:	48 63 d2             	movslq %edx,%rdx
  802703:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802707:	8b 00                	mov    (%rax),%eax
  802709:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80270c:	75 22                	jne    802730 <dev_lookup+0x55>
			*dev = devtab[i];
  80270e:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802715:	00 00 00 
  802718:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80271b:	48 63 d2             	movslq %edx,%rdx
  80271e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802722:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802726:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
  80272e:	eb 60                	jmp    802790 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802730:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802734:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80273b:	00 00 00 
  80273e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802741:	48 63 d2             	movslq %edx,%rdx
  802744:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802748:	48 85 c0             	test   %rax,%rax
  80274b:	75 a6                	jne    8026f3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80274d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802754:	00 00 00 
  802757:	48 8b 00             	mov    (%rax),%rax
  80275a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802760:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802763:	89 c6                	mov    %eax,%esi
  802765:	48 bf b8 55 80 00 00 	movabs $0x8055b8,%rdi
  80276c:	00 00 00 
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	48 b9 43 0c 80 00 00 	movabs $0x800c43,%rcx
  80277b:	00 00 00 
  80277e:	ff d1                	callq  *%rcx
	*dev = 0;
  802780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802784:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80278b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802790:	c9                   	leaveq 
  802791:	c3                   	retq   

0000000000802792 <close>:

int
close(int fdnum)
{
  802792:	55                   	push   %rbp
  802793:	48 89 e5             	mov    %rsp,%rbp
  802796:	48 83 ec 20          	sub    $0x20,%rsp
  80279a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80279d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027a4:	48 89 d6             	mov    %rdx,%rsi
  8027a7:	89 c7                	mov    %eax,%edi
  8027a9:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  8027b0:	00 00 00 
  8027b3:	ff d0                	callq  *%rax
  8027b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bc:	79 05                	jns    8027c3 <close+0x31>
		return r;
  8027be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c1:	eb 18                	jmp    8027db <close+0x49>
	else
		return fd_close(fd, 1);
  8027c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c7:	be 01 00 00 00       	mov    $0x1,%esi
  8027cc:	48 89 c7             	mov    %rax,%rdi
  8027cf:	48 b8 12 26 80 00 00 	movabs $0x802612,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
}
  8027db:	c9                   	leaveq 
  8027dc:	c3                   	retq   

00000000008027dd <close_all>:

void
close_all(void)
{
  8027dd:	55                   	push   %rbp
  8027de:	48 89 e5             	mov    %rsp,%rbp
  8027e1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027ec:	eb 15                	jmp    802803 <close_all+0x26>
		close(i);
  8027ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f1:	89 c7                	mov    %eax,%edi
  8027f3:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  8027fa:	00 00 00 
  8027fd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027ff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802803:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802807:	7e e5                	jle    8027ee <close_all+0x11>
		close(i);
}
  802809:	c9                   	leaveq 
  80280a:	c3                   	retq   

000000000080280b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80280b:	55                   	push   %rbp
  80280c:	48 89 e5             	mov    %rsp,%rbp
  80280f:	48 83 ec 40          	sub    $0x40,%rsp
  802813:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802816:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802819:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80281d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802820:	48 89 d6             	mov    %rdx,%rsi
  802823:	89 c7                	mov    %eax,%edi
  802825:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  80282c:	00 00 00 
  80282f:	ff d0                	callq  *%rax
  802831:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802834:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802838:	79 08                	jns    802842 <dup+0x37>
		return r;
  80283a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283d:	e9 70 01 00 00       	jmpq   8029b2 <dup+0x1a7>
	close(newfdnum);
  802842:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802845:	89 c7                	mov    %eax,%edi
  802847:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  80284e:	00 00 00 
  802851:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802853:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802856:	48 98                	cltq   
  802858:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80285e:	48 c1 e0 0c          	shl    $0xc,%rax
  802862:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286a:	48 89 c7             	mov    %rax,%rdi
  80286d:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  802874:	00 00 00 
  802877:	ff d0                	callq  *%rax
  802879:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80287d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802881:	48 89 c7             	mov    %rax,%rdi
  802884:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  80288b:	00 00 00 
  80288e:	ff d0                	callq  *%rax
  802890:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802898:	48 89 c2             	mov    %rax,%rdx
  80289b:	48 c1 ea 15          	shr    $0x15,%rdx
  80289f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028a6:	01 00 00 
  8028a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028ad:	83 e0 01             	and    $0x1,%eax
  8028b0:	84 c0                	test   %al,%al
  8028b2:	74 71                	je     802925 <dup+0x11a>
  8028b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b8:	48 89 c2             	mov    %rax,%rdx
  8028bb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8028bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028c6:	01 00 00 
  8028c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028cd:	83 e0 01             	and    $0x1,%eax
  8028d0:	84 c0                	test   %al,%al
  8028d2:	74 51                	je     802925 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d8:	48 89 c2             	mov    %rax,%rdx
  8028db:	48 c1 ea 0c          	shr    $0xc,%rdx
  8028df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028e6:	01 00 00 
  8028e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028ed:	89 c1                	mov    %eax,%ecx
  8028ef:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8028f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fd:	41 89 c8             	mov    %ecx,%r8d
  802900:	48 89 d1             	mov    %rdx,%rcx
  802903:	ba 00 00 00 00       	mov    $0x0,%edx
  802908:	48 89 c6             	mov    %rax,%rsi
  80290b:	bf 00 00 00 00       	mov    $0x0,%edi
  802910:	48 b8 9c 21 80 00 00 	movabs $0x80219c,%rax
  802917:	00 00 00 
  80291a:	ff d0                	callq  *%rax
  80291c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802923:	78 56                	js     80297b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802929:	48 89 c2             	mov    %rax,%rdx
  80292c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802930:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802937:	01 00 00 
  80293a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293e:	89 c1                	mov    %eax,%ecx
  802940:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80294a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80294e:	41 89 c8             	mov    %ecx,%r8d
  802951:	48 89 d1             	mov    %rdx,%rcx
  802954:	ba 00 00 00 00       	mov    $0x0,%edx
  802959:	48 89 c6             	mov    %rax,%rsi
  80295c:	bf 00 00 00 00       	mov    $0x0,%edi
  802961:	48 b8 9c 21 80 00 00 	movabs $0x80219c,%rax
  802968:	00 00 00 
  80296b:	ff d0                	callq  *%rax
  80296d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802970:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802974:	78 08                	js     80297e <dup+0x173>
		goto err;

	return newfdnum;
  802976:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802979:	eb 37                	jmp    8029b2 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80297b:	90                   	nop
  80297c:	eb 01                	jmp    80297f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80297e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80297f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802983:	48 89 c6             	mov    %rax,%rsi
  802986:	bf 00 00 00 00       	mov    $0x0,%edi
  80298b:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  802992:	00 00 00 
  802995:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802997:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80299b:	48 89 c6             	mov    %rax,%rsi
  80299e:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a3:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  8029aa:	00 00 00 
  8029ad:	ff d0                	callq  *%rax
	return r;
  8029af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029b2:	c9                   	leaveq 
  8029b3:	c3                   	retq   

00000000008029b4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029b4:	55                   	push   %rbp
  8029b5:	48 89 e5             	mov    %rsp,%rbp
  8029b8:	48 83 ec 40          	sub    $0x40,%rsp
  8029bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029ce:	48 89 d6             	mov    %rdx,%rsi
  8029d1:	89 c7                	mov    %eax,%edi
  8029d3:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  8029da:	00 00 00 
  8029dd:	ff d0                	callq  *%rax
  8029df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e6:	78 24                	js     802a0c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ec:	8b 00                	mov    (%rax),%eax
  8029ee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029f2:	48 89 d6             	mov    %rdx,%rsi
  8029f5:	89 c7                	mov    %eax,%edi
  8029f7:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  8029fe:	00 00 00 
  802a01:	ff d0                	callq  *%rax
  802a03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0a:	79 05                	jns    802a11 <read+0x5d>
		return r;
  802a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0f:	eb 7a                	jmp    802a8b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a15:	8b 40 08             	mov    0x8(%rax),%eax
  802a18:	83 e0 03             	and    $0x3,%eax
  802a1b:	83 f8 01             	cmp    $0x1,%eax
  802a1e:	75 3a                	jne    802a5a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a20:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802a27:	00 00 00 
  802a2a:	48 8b 00             	mov    (%rax),%rax
  802a2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a36:	89 c6                	mov    %eax,%esi
  802a38:	48 bf d7 55 80 00 00 	movabs $0x8055d7,%rdi
  802a3f:	00 00 00 
  802a42:	b8 00 00 00 00       	mov    $0x0,%eax
  802a47:	48 b9 43 0c 80 00 00 	movabs $0x800c43,%rcx
  802a4e:	00 00 00 
  802a51:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a58:	eb 31                	jmp    802a8b <read+0xd7>
	}
	if (!dev->dev_read)
  802a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a62:	48 85 c0             	test   %rax,%rax
  802a65:	75 07                	jne    802a6e <read+0xba>
		return -E_NOT_SUPP;
  802a67:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a6c:	eb 1d                	jmp    802a8b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a72:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802a76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a7e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a82:	48 89 ce             	mov    %rcx,%rsi
  802a85:	48 89 c7             	mov    %rax,%rdi
  802a88:	41 ff d0             	callq  *%r8
}
  802a8b:	c9                   	leaveq 
  802a8c:	c3                   	retq   

0000000000802a8d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a8d:	55                   	push   %rbp
  802a8e:	48 89 e5             	mov    %rsp,%rbp
  802a91:	48 83 ec 30          	sub    $0x30,%rsp
  802a95:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802aa0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aa7:	eb 46                	jmp    802aef <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802aa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aac:	48 98                	cltq   
  802aae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ab2:	48 29 c2             	sub    %rax,%rdx
  802ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab8:	48 98                	cltq   
  802aba:	48 89 c1             	mov    %rax,%rcx
  802abd:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802ac1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ac4:	48 89 ce             	mov    %rcx,%rsi
  802ac7:	89 c7                	mov    %eax,%edi
  802ac9:	48 b8 b4 29 80 00 00 	movabs $0x8029b4,%rax
  802ad0:	00 00 00 
  802ad3:	ff d0                	callq  *%rax
  802ad5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ad8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802adc:	79 05                	jns    802ae3 <readn+0x56>
			return m;
  802ade:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae1:	eb 1d                	jmp    802b00 <readn+0x73>
		if (m == 0)
  802ae3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ae7:	74 13                	je     802afc <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ae9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aec:	01 45 fc             	add    %eax,-0x4(%rbp)
  802aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af2:	48 98                	cltq   
  802af4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802af8:	72 af                	jb     802aa9 <readn+0x1c>
  802afa:	eb 01                	jmp    802afd <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802afc:	90                   	nop
	}
	return tot;
  802afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b00:	c9                   	leaveq 
  802b01:	c3                   	retq   

0000000000802b02 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b02:	55                   	push   %rbp
  802b03:	48 89 e5             	mov    %rsp,%rbp
  802b06:	48 83 ec 40          	sub    $0x40,%rsp
  802b0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b0d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b11:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b15:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b19:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b1c:	48 89 d6             	mov    %rdx,%rsi
  802b1f:	89 c7                	mov    %eax,%edi
  802b21:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  802b28:	00 00 00 
  802b2b:	ff d0                	callq  *%rax
  802b2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b34:	78 24                	js     802b5a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3a:	8b 00                	mov    (%rax),%eax
  802b3c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b40:	48 89 d6             	mov    %rdx,%rsi
  802b43:	89 c7                	mov    %eax,%edi
  802b45:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  802b4c:	00 00 00 
  802b4f:	ff d0                	callq  *%rax
  802b51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b58:	79 05                	jns    802b5f <write+0x5d>
		return r;
  802b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5d:	eb 79                	jmp    802bd8 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b63:	8b 40 08             	mov    0x8(%rax),%eax
  802b66:	83 e0 03             	and    $0x3,%eax
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	75 3a                	jne    802ba7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b6d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802b74:	00 00 00 
  802b77:	48 8b 00             	mov    (%rax),%rax
  802b7a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b80:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b83:	89 c6                	mov    %eax,%esi
  802b85:	48 bf f3 55 80 00 00 	movabs $0x8055f3,%rdi
  802b8c:	00 00 00 
  802b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b94:	48 b9 43 0c 80 00 00 	movabs $0x800c43,%rcx
  802b9b:	00 00 00 
  802b9e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ba0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ba5:	eb 31                	jmp    802bd8 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ba7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bab:	48 8b 40 18          	mov    0x18(%rax),%rax
  802baf:	48 85 c0             	test   %rax,%rax
  802bb2:	75 07                	jne    802bbb <write+0xb9>
		return -E_NOT_SUPP;
  802bb4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bb9:	eb 1d                	jmp    802bd8 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802bbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbf:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802bc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bcb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bcf:	48 89 ce             	mov    %rcx,%rsi
  802bd2:	48 89 c7             	mov    %rax,%rdi
  802bd5:	41 ff d0             	callq  *%r8
}
  802bd8:	c9                   	leaveq 
  802bd9:	c3                   	retq   

0000000000802bda <seek>:

int
seek(int fdnum, off_t offset)
{
  802bda:	55                   	push   %rbp
  802bdb:	48 89 e5             	mov    %rsp,%rbp
  802bde:	48 83 ec 18          	sub    $0x18,%rsp
  802be2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802be5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802be8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bef:	48 89 d6             	mov    %rdx,%rsi
  802bf2:	89 c7                	mov    %eax,%edi
  802bf4:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  802bfb:	00 00 00 
  802bfe:	ff d0                	callq  *%rax
  802c00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c07:	79 05                	jns    802c0e <seek+0x34>
		return r;
  802c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0c:	eb 0f                	jmp    802c1d <seek+0x43>
	fd->fd_offset = offset;
  802c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c12:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c15:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c1d:	c9                   	leaveq 
  802c1e:	c3                   	retq   

0000000000802c1f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c1f:	55                   	push   %rbp
  802c20:	48 89 e5             	mov    %rsp,%rbp
  802c23:	48 83 ec 30          	sub    $0x30,%rsp
  802c27:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c2a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c2d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c31:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c34:	48 89 d6             	mov    %rdx,%rsi
  802c37:	89 c7                	mov    %eax,%edi
  802c39:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  802c40:	00 00 00 
  802c43:	ff d0                	callq  *%rax
  802c45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4c:	78 24                	js     802c72 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c52:	8b 00                	mov    (%rax),%eax
  802c54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c58:	48 89 d6             	mov    %rdx,%rsi
  802c5b:	89 c7                	mov    %eax,%edi
  802c5d:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  802c64:	00 00 00 
  802c67:	ff d0                	callq  *%rax
  802c69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c70:	79 05                	jns    802c77 <ftruncate+0x58>
		return r;
  802c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c75:	eb 72                	jmp    802ce9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7b:	8b 40 08             	mov    0x8(%rax),%eax
  802c7e:	83 e0 03             	and    $0x3,%eax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	75 3a                	jne    802cbf <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c85:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802c8c:	00 00 00 
  802c8f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c92:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c98:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c9b:	89 c6                	mov    %eax,%esi
  802c9d:	48 bf 10 56 80 00 00 	movabs $0x805610,%rdi
  802ca4:	00 00 00 
  802ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cac:	48 b9 43 0c 80 00 00 	movabs $0x800c43,%rcx
  802cb3:	00 00 00 
  802cb6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cb8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cbd:	eb 2a                	jmp    802ce9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc3:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cc7:	48 85 c0             	test   %rax,%rax
  802cca:	75 07                	jne    802cd3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ccc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cd1:	eb 16                	jmp    802ce9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd7:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802cdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802ce2:	89 d6                	mov    %edx,%esi
  802ce4:	48 89 c7             	mov    %rax,%rdi
  802ce7:	ff d1                	callq  *%rcx
}
  802ce9:	c9                   	leaveq 
  802cea:	c3                   	retq   

0000000000802ceb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ceb:	55                   	push   %rbp
  802cec:	48 89 e5             	mov    %rsp,%rbp
  802cef:	48 83 ec 30          	sub    $0x30,%rsp
  802cf3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cf6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cfa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cfe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d01:	48 89 d6             	mov    %rdx,%rsi
  802d04:	89 c7                	mov    %eax,%edi
  802d06:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  802d0d:	00 00 00 
  802d10:	ff d0                	callq  *%rax
  802d12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d19:	78 24                	js     802d3f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1f:	8b 00                	mov    (%rax),%eax
  802d21:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d25:	48 89 d6             	mov    %rdx,%rsi
  802d28:	89 c7                	mov    %eax,%edi
  802d2a:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
  802d36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3d:	79 05                	jns    802d44 <fstat+0x59>
		return r;
  802d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d42:	eb 5e                	jmp    802da2 <fstat+0xb7>
	if (!dev->dev_stat)
  802d44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d48:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d4c:	48 85 c0             	test   %rax,%rax
  802d4f:	75 07                	jne    802d58 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d51:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d56:	eb 4a                	jmp    802da2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d5c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d63:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d6a:	00 00 00 
	stat->st_isdir = 0;
  802d6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d71:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d78:	00 00 00 
	stat->st_dev = dev;
  802d7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d83:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802d92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d96:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802d9a:	48 89 d6             	mov    %rdx,%rsi
  802d9d:	48 89 c7             	mov    %rax,%rdi
  802da0:	ff d1                	callq  *%rcx
}
  802da2:	c9                   	leaveq 
  802da3:	c3                   	retq   

0000000000802da4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802da4:	55                   	push   %rbp
  802da5:	48 89 e5             	mov    %rsp,%rbp
  802da8:	48 83 ec 20          	sub    $0x20,%rsp
  802dac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802db0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db8:	be 00 00 00 00       	mov    $0x0,%esi
  802dbd:	48 89 c7             	mov    %rax,%rdi
  802dc0:	48 b8 93 2e 80 00 00 	movabs $0x802e93,%rax
  802dc7:	00 00 00 
  802dca:	ff d0                	callq  *%rax
  802dcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd3:	79 05                	jns    802dda <stat+0x36>
		return fd;
  802dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd8:	eb 2f                	jmp    802e09 <stat+0x65>
	r = fstat(fd, stat);
  802dda:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de1:	48 89 d6             	mov    %rdx,%rsi
  802de4:	89 c7                	mov    %eax,%edi
  802de6:	48 b8 eb 2c 80 00 00 	movabs $0x802ceb,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
  802df2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df8:	89 c7                	mov    %eax,%edi
  802dfa:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
	return r;
  802e06:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e09:	c9                   	leaveq 
  802e0a:	c3                   	retq   
	...

0000000000802e0c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e0c:	55                   	push   %rbp
  802e0d:	48 89 e5             	mov    %rsp,%rbp
  802e10:	48 83 ec 10          	sub    $0x10,%rsp
  802e14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e1b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e22:	00 00 00 
  802e25:	8b 00                	mov    (%rax),%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	75 1d                	jne    802e48 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e2b:	bf 01 00 00 00       	mov    $0x1,%edi
  802e30:	48 b8 6e 48 80 00 00 	movabs $0x80486e,%rax
  802e37:	00 00 00 
  802e3a:	ff d0                	callq  *%rax
  802e3c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e43:	00 00 00 
  802e46:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e48:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e4f:	00 00 00 
  802e52:	8b 00                	mov    (%rax),%eax
  802e54:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e57:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e5c:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802e63:	00 00 00 
  802e66:	89 c7                	mov    %eax,%edi
  802e68:	48 b8 bf 47 80 00 00 	movabs $0x8047bf,%rax
  802e6f:	00 00 00 
  802e72:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e78:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7d:	48 89 c6             	mov    %rax,%rsi
  802e80:	bf 00 00 00 00       	mov    $0x0,%edi
  802e85:	48 b8 d8 46 80 00 00 	movabs $0x8046d8,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
}
  802e91:	c9                   	leaveq 
  802e92:	c3                   	retq   

0000000000802e93 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802e93:	55                   	push   %rbp
  802e94:	48 89 e5             	mov    %rsp,%rbp
  802e97:	48 83 ec 20          	sub    $0x20,%rsp
  802e9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e9f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea6:	48 89 c7             	mov    %rax,%rdi
  802ea9:	48 b8 a8 17 80 00 00 	movabs $0x8017a8,%rax
  802eb0:	00 00 00 
  802eb3:	ff d0                	callq  *%rax
  802eb5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802eba:	7e 0a                	jle    802ec6 <open+0x33>
		return -E_BAD_PATH;
  802ebc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ec1:	e9 a5 00 00 00       	jmpq   802f6b <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802ec6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802eca:	48 89 c7             	mov    %rax,%rdi
  802ecd:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802ed4:	00 00 00 
  802ed7:	ff d0                	callq  *%rax
  802ed9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802edc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee0:	79 08                	jns    802eea <open+0x57>
		return r;
  802ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee5:	e9 81 00 00 00       	jmpq   802f6b <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  802eea:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ef1:	00 00 00 
  802ef4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802ef7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f01:	48 89 c6             	mov    %rax,%rsi
  802f04:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f0b:	00 00 00 
  802f0e:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  802f1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1e:	48 89 c6             	mov    %rax,%rsi
  802f21:	bf 01 00 00 00       	mov    $0x1,%edi
  802f26:	48 b8 0c 2e 80 00 00 	movabs $0x802e0c,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
  802f32:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802f35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f39:	79 1d                	jns    802f58 <open+0xc5>
		fd_close(new_fd, 0);
  802f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3f:	be 00 00 00 00       	mov    $0x0,%esi
  802f44:	48 89 c7             	mov    %rax,%rdi
  802f47:	48 b8 12 26 80 00 00 	movabs $0x802612,%rax
  802f4e:	00 00 00 
  802f51:	ff d0                	callq  *%rax
		return r;	
  802f53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f56:	eb 13                	jmp    802f6b <open+0xd8>
	}
	return fd2num(new_fd);
  802f58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5c:	48 89 c7             	mov    %rax,%rdi
  802f5f:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  802f66:	00 00 00 
  802f69:	ff d0                	callq  *%rax
}
  802f6b:	c9                   	leaveq 
  802f6c:	c3                   	retq   

0000000000802f6d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f6d:	55                   	push   %rbp
  802f6e:	48 89 e5             	mov    %rsp,%rbp
  802f71:	48 83 ec 10          	sub    $0x10,%rsp
  802f75:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f7d:	8b 50 0c             	mov    0xc(%rax),%edx
  802f80:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f87:	00 00 00 
  802f8a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f8c:	be 00 00 00 00       	mov    $0x0,%esi
  802f91:	bf 06 00 00 00       	mov    $0x6,%edi
  802f96:	48 b8 0c 2e 80 00 00 	movabs $0x802e0c,%rax
  802f9d:	00 00 00 
  802fa0:	ff d0                	callq  *%rax
}
  802fa2:	c9                   	leaveq 
  802fa3:	c3                   	retq   

0000000000802fa4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fa4:	55                   	push   %rbp
  802fa5:	48 89 e5             	mov    %rsp,%rbp
  802fa8:	48 83 ec 30          	sub    $0x30,%rsp
  802fac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fb4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802fb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fbc:	8b 50 0c             	mov    0xc(%rax),%edx
  802fbf:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc6:	00 00 00 
  802fc9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fcb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fd2:	00 00 00 
  802fd5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fd9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802fdd:	be 00 00 00 00       	mov    $0x0,%esi
  802fe2:	bf 03 00 00 00       	mov    $0x3,%edi
  802fe7:	48 b8 0c 2e 80 00 00 	movabs $0x802e0c,%rax
  802fee:	00 00 00 
  802ff1:	ff d0                	callq  *%rax
  802ff3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802ff6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffa:	7e 23                	jle    80301f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  802ffc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fff:	48 63 d0             	movslq %eax,%rdx
  803002:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803006:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80300d:	00 00 00 
  803010:	48 89 c7             	mov    %rax,%rdi
  803013:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
	}
	return nbytes;
  80301f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803022:	c9                   	leaveq 
  803023:	c3                   	retq   

0000000000803024 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803024:	55                   	push   %rbp
  803025:	48 89 e5             	mov    %rsp,%rbp
  803028:	48 83 ec 20          	sub    $0x20,%rsp
  80302c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803030:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803038:	8b 50 0c             	mov    0xc(%rax),%edx
  80303b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803042:	00 00 00 
  803045:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803047:	be 00 00 00 00       	mov    $0x0,%esi
  80304c:	bf 05 00 00 00       	mov    $0x5,%edi
  803051:	48 b8 0c 2e 80 00 00 	movabs $0x802e0c,%rax
  803058:	00 00 00 
  80305b:	ff d0                	callq  *%rax
  80305d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803060:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803064:	79 05                	jns    80306b <devfile_stat+0x47>
		return r;
  803066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803069:	eb 56                	jmp    8030c1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80306b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80306f:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803076:	00 00 00 
  803079:	48 89 c7             	mov    %rax,%rdi
  80307c:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803083:	00 00 00 
  803086:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803088:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80308f:	00 00 00 
  803092:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803098:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80309c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8030a2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030a9:	00 00 00 
  8030ac:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030c1:	c9                   	leaveq 
  8030c2:	c3                   	retq   
	...

00000000008030c4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8030c4:	55                   	push   %rbp
  8030c5:	48 89 e5             	mov    %rsp,%rbp
  8030c8:	48 83 ec 20          	sub    $0x20,%rsp
  8030cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8030cf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030d6:	48 89 d6             	mov    %rdx,%rsi
  8030d9:	89 c7                	mov    %eax,%edi
  8030db:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  8030e2:	00 00 00 
  8030e5:	ff d0                	callq  *%rax
  8030e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ee:	79 05                	jns    8030f5 <fd2sockid+0x31>
		return r;
  8030f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f3:	eb 24                	jmp    803119 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8030f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f9:	8b 10                	mov    (%rax),%edx
  8030fb:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803102:	00 00 00 
  803105:	8b 00                	mov    (%rax),%eax
  803107:	39 c2                	cmp    %eax,%edx
  803109:	74 07                	je     803112 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80310b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803110:	eb 07                	jmp    803119 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803112:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803116:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803119:	c9                   	leaveq 
  80311a:	c3                   	retq   

000000000080311b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80311b:	55                   	push   %rbp
  80311c:	48 89 e5             	mov    %rsp,%rbp
  80311f:	48 83 ec 20          	sub    $0x20,%rsp
  803123:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803126:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80312a:	48 89 c7             	mov    %rax,%rdi
  80312d:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803134:	00 00 00 
  803137:	ff d0                	callq  *%rax
  803139:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80313c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803140:	78 26                	js     803168 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803142:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803146:	ba 07 04 00 00       	mov    $0x407,%edx
  80314b:	48 89 c6             	mov    %rax,%rsi
  80314e:	bf 00 00 00 00       	mov    $0x0,%edi
  803153:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  80315a:	00 00 00 
  80315d:	ff d0                	callq  *%rax
  80315f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803162:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803166:	79 16                	jns    80317e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803168:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80316b:	89 c7                	mov    %eax,%edi
  80316d:	48 b8 28 36 80 00 00 	movabs $0x803628,%rax
  803174:	00 00 00 
  803177:	ff d0                	callq  *%rax
		return r;
  803179:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317c:	eb 3a                	jmp    8031b8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80317e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803182:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803189:	00 00 00 
  80318c:	8b 12                	mov    (%rdx),%edx
  80318e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803190:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803194:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80319b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031a2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8031a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a9:	48 89 c7             	mov    %rax,%rdi
  8031ac:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  8031b3:	00 00 00 
  8031b6:	ff d0                	callq  *%rax
}
  8031b8:	c9                   	leaveq 
  8031b9:	c3                   	retq   

00000000008031ba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031ba:	55                   	push   %rbp
  8031bb:	48 89 e5             	mov    %rsp,%rbp
  8031be:	48 83 ec 30          	sub    $0x30,%rsp
  8031c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031d0:	89 c7                	mov    %eax,%edi
  8031d2:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
  8031de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e5:	79 05                	jns    8031ec <accept+0x32>
		return r;
  8031e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ea:	eb 3b                	jmp    803227 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8031ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031f0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f7:	48 89 ce             	mov    %rcx,%rsi
  8031fa:	89 c7                	mov    %eax,%edi
  8031fc:	48 b8 05 35 80 00 00 	movabs $0x803505,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
  803208:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80320b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80320f:	79 05                	jns    803216 <accept+0x5c>
		return r;
  803211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803214:	eb 11                	jmp    803227 <accept+0x6d>
	return alloc_sockfd(r);
  803216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803219:	89 c7                	mov    %eax,%edi
  80321b:	48 b8 1b 31 80 00 00 	movabs $0x80311b,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
}
  803227:	c9                   	leaveq 
  803228:	c3                   	retq   

0000000000803229 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803229:	55                   	push   %rbp
  80322a:	48 89 e5             	mov    %rsp,%rbp
  80322d:	48 83 ec 20          	sub    $0x20,%rsp
  803231:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803234:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803238:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80323b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80323e:	89 c7                	mov    %eax,%edi
  803240:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  803247:	00 00 00 
  80324a:	ff d0                	callq  *%rax
  80324c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803253:	79 05                	jns    80325a <bind+0x31>
		return r;
  803255:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803258:	eb 1b                	jmp    803275 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80325a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80325d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803264:	48 89 ce             	mov    %rcx,%rsi
  803267:	89 c7                	mov    %eax,%edi
  803269:	48 b8 84 35 80 00 00 	movabs $0x803584,%rax
  803270:	00 00 00 
  803273:	ff d0                	callq  *%rax
}
  803275:	c9                   	leaveq 
  803276:	c3                   	retq   

0000000000803277 <shutdown>:

int
shutdown(int s, int how)
{
  803277:	55                   	push   %rbp
  803278:	48 89 e5             	mov    %rsp,%rbp
  80327b:	48 83 ec 20          	sub    $0x20,%rsp
  80327f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803282:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803285:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803288:	89 c7                	mov    %eax,%edi
  80328a:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  803291:	00 00 00 
  803294:	ff d0                	callq  *%rax
  803296:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803299:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80329d:	79 05                	jns    8032a4 <shutdown+0x2d>
		return r;
  80329f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a2:	eb 16                	jmp    8032ba <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8032a4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032aa:	89 d6                	mov    %edx,%esi
  8032ac:	89 c7                	mov    %eax,%edi
  8032ae:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax
}
  8032ba:	c9                   	leaveq 
  8032bb:	c3                   	retq   

00000000008032bc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8032bc:	55                   	push   %rbp
  8032bd:	48 89 e5             	mov    %rsp,%rbp
  8032c0:	48 83 ec 10          	sub    $0x10,%rsp
  8032c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8032c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032cc:	48 89 c7             	mov    %rax,%rdi
  8032cf:	48 b8 fc 48 80 00 00 	movabs $0x8048fc,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
  8032db:	83 f8 01             	cmp    $0x1,%eax
  8032de:	75 17                	jne    8032f7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8032e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032e4:	8b 40 0c             	mov    0xc(%rax),%eax
  8032e7:	89 c7                	mov    %eax,%edi
  8032e9:	48 b8 28 36 80 00 00 	movabs $0x803628,%rax
  8032f0:	00 00 00 
  8032f3:	ff d0                	callq  *%rax
  8032f5:	eb 05                	jmp    8032fc <devsock_close+0x40>
	else
		return 0;
  8032f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032fc:	c9                   	leaveq 
  8032fd:	c3                   	retq   

00000000008032fe <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032fe:	55                   	push   %rbp
  8032ff:	48 89 e5             	mov    %rsp,%rbp
  803302:	48 83 ec 20          	sub    $0x20,%rsp
  803306:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803309:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80330d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803310:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803313:	89 c7                	mov    %eax,%edi
  803315:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	callq  *%rax
  803321:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803324:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803328:	79 05                	jns    80332f <connect+0x31>
		return r;
  80332a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332d:	eb 1b                	jmp    80334a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80332f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803332:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803336:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803339:	48 89 ce             	mov    %rcx,%rsi
  80333c:	89 c7                	mov    %eax,%edi
  80333e:	48 b8 55 36 80 00 00 	movabs $0x803655,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
}
  80334a:	c9                   	leaveq 
  80334b:	c3                   	retq   

000000000080334c <listen>:

int
listen(int s, int backlog)
{
  80334c:	55                   	push   %rbp
  80334d:	48 89 e5             	mov    %rsp,%rbp
  803350:	48 83 ec 20          	sub    $0x20,%rsp
  803354:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803357:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80335a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80335d:	89 c7                	mov    %eax,%edi
  80335f:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  803366:	00 00 00 
  803369:	ff d0                	callq  *%rax
  80336b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80336e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803372:	79 05                	jns    803379 <listen+0x2d>
		return r;
  803374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803377:	eb 16                	jmp    80338f <listen+0x43>
	return nsipc_listen(r, backlog);
  803379:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80337c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337f:	89 d6                	mov    %edx,%esi
  803381:	89 c7                	mov    %eax,%edi
  803383:	48 b8 b9 36 80 00 00 	movabs $0x8036b9,%rax
  80338a:	00 00 00 
  80338d:	ff d0                	callq  *%rax
}
  80338f:	c9                   	leaveq 
  803390:	c3                   	retq   

0000000000803391 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803391:	55                   	push   %rbp
  803392:	48 89 e5             	mov    %rsp,%rbp
  803395:	48 83 ec 20          	sub    $0x20,%rsp
  803399:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80339d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8033a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a9:	89 c2                	mov    %eax,%edx
  8033ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033af:	8b 40 0c             	mov    0xc(%rax),%eax
  8033b2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8033b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8033bb:	89 c7                	mov    %eax,%edi
  8033bd:	48 b8 f9 36 80 00 00 	movabs $0x8036f9,%rax
  8033c4:	00 00 00 
  8033c7:	ff d0                	callq  *%rax
}
  8033c9:	c9                   	leaveq 
  8033ca:	c3                   	retq   

00000000008033cb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8033cb:	55                   	push   %rbp
  8033cc:	48 89 e5             	mov    %rsp,%rbp
  8033cf:	48 83 ec 20          	sub    $0x20,%rsp
  8033d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033db:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e3:	89 c2                	mov    %eax,%edx
  8033e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e9:	8b 40 0c             	mov    0xc(%rax),%eax
  8033ec:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8033f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8033f5:	89 c7                	mov    %eax,%edi
  8033f7:	48 b8 c5 37 80 00 00 	movabs $0x8037c5,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
}
  803403:	c9                   	leaveq 
  803404:	c3                   	retq   

0000000000803405 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803405:	55                   	push   %rbp
  803406:	48 89 e5             	mov    %rsp,%rbp
  803409:	48 83 ec 10          	sub    $0x10,%rsp
  80340d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803411:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803419:	48 be 3b 56 80 00 00 	movabs $0x80563b,%rsi
  803420:	00 00 00 
  803423:	48 89 c7             	mov    %rax,%rdi
  803426:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  80342d:	00 00 00 
  803430:	ff d0                	callq  *%rax
	return 0;
  803432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803437:	c9                   	leaveq 
  803438:	c3                   	retq   

0000000000803439 <socket>:

int
socket(int domain, int type, int protocol)
{
  803439:	55                   	push   %rbp
  80343a:	48 89 e5             	mov    %rsp,%rbp
  80343d:	48 83 ec 20          	sub    $0x20,%rsp
  803441:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803444:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803447:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80344a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80344d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803450:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803453:	89 ce                	mov    %ecx,%esi
  803455:	89 c7                	mov    %eax,%edi
  803457:	48 b8 7d 38 80 00 00 	movabs $0x80387d,%rax
  80345e:	00 00 00 
  803461:	ff d0                	callq  *%rax
  803463:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803466:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80346a:	79 05                	jns    803471 <socket+0x38>
		return r;
  80346c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346f:	eb 11                	jmp    803482 <socket+0x49>
	return alloc_sockfd(r);
  803471:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803474:	89 c7                	mov    %eax,%edi
  803476:	48 b8 1b 31 80 00 00 	movabs $0x80311b,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax
}
  803482:	c9                   	leaveq 
  803483:	c3                   	retq   

0000000000803484 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803484:	55                   	push   %rbp
  803485:	48 89 e5             	mov    %rsp,%rbp
  803488:	48 83 ec 10          	sub    $0x10,%rsp
  80348c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80348f:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803496:	00 00 00 
  803499:	8b 00                	mov    (%rax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	75 1d                	jne    8034bc <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80349f:	bf 02 00 00 00       	mov    $0x2,%edi
  8034a4:	48 b8 6e 48 80 00 00 	movabs $0x80486e,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
  8034b0:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8034b7:	00 00 00 
  8034ba:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8034bc:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8034c3:	00 00 00 
  8034c6:	8b 00                	mov    (%rax),%eax
  8034c8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8034cb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8034d0:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8034d7:	00 00 00 
  8034da:	89 c7                	mov    %eax,%edi
  8034dc:	48 b8 bf 47 80 00 00 	movabs $0x8047bf,%rax
  8034e3:	00 00 00 
  8034e6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8034e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8034ed:	be 00 00 00 00       	mov    $0x0,%esi
  8034f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8034f7:	48 b8 d8 46 80 00 00 	movabs $0x8046d8,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
}
  803503:	c9                   	leaveq 
  803504:	c3                   	retq   

0000000000803505 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803505:	55                   	push   %rbp
  803506:	48 89 e5             	mov    %rsp,%rbp
  803509:	48 83 ec 30          	sub    $0x30,%rsp
  80350d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803510:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803514:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803518:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80351f:	00 00 00 
  803522:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803525:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803527:	bf 01 00 00 00       	mov    $0x1,%edi
  80352c:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
  803538:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353f:	78 3e                	js     80357f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803541:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803548:	00 00 00 
  80354b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80354f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803553:	8b 40 10             	mov    0x10(%rax),%eax
  803556:	89 c2                	mov    %eax,%edx
  803558:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80355c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803560:	48 89 ce             	mov    %rcx,%rsi
  803563:	48 89 c7             	mov    %rax,%rdi
  803566:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  80356d:	00 00 00 
  803570:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803576:	8b 50 10             	mov    0x10(%rax),%edx
  803579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80357d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80357f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803582:	c9                   	leaveq 
  803583:	c3                   	retq   

0000000000803584 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803584:	55                   	push   %rbp
  803585:	48 89 e5             	mov    %rsp,%rbp
  803588:	48 83 ec 10          	sub    $0x10,%rsp
  80358c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80358f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803593:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803596:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80359d:	00 00 00 
  8035a0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035a3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8035a5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ac:	48 89 c6             	mov    %rax,%rsi
  8035af:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8035b6:	00 00 00 
  8035b9:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8035c0:	00 00 00 
  8035c3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8035c5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035cc:	00 00 00 
  8035cf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035d2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8035d5:	bf 02 00 00 00       	mov    $0x2,%edi
  8035da:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  8035e1:	00 00 00 
  8035e4:	ff d0                	callq  *%rax
}
  8035e6:	c9                   	leaveq 
  8035e7:	c3                   	retq   

00000000008035e8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8035e8:	55                   	push   %rbp
  8035e9:	48 89 e5             	mov    %rsp,%rbp
  8035ec:	48 83 ec 10          	sub    $0x10,%rsp
  8035f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035f3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8035f6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035fd:	00 00 00 
  803600:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803603:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803605:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80360c:	00 00 00 
  80360f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803612:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803615:	bf 03 00 00 00       	mov    $0x3,%edi
  80361a:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  803621:	00 00 00 
  803624:	ff d0                	callq  *%rax
}
  803626:	c9                   	leaveq 
  803627:	c3                   	retq   

0000000000803628 <nsipc_close>:

int
nsipc_close(int s)
{
  803628:	55                   	push   %rbp
  803629:	48 89 e5             	mov    %rsp,%rbp
  80362c:	48 83 ec 10          	sub    $0x10,%rsp
  803630:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803633:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80363a:	00 00 00 
  80363d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803640:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803642:	bf 04 00 00 00       	mov    $0x4,%edi
  803647:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
}
  803653:	c9                   	leaveq 
  803654:	c3                   	retq   

0000000000803655 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803655:	55                   	push   %rbp
  803656:	48 89 e5             	mov    %rsp,%rbp
  803659:	48 83 ec 10          	sub    $0x10,%rsp
  80365d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803660:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803664:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803667:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80366e:	00 00 00 
  803671:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803674:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803676:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367d:	48 89 c6             	mov    %rax,%rsi
  803680:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803687:	00 00 00 
  80368a:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803696:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80369d:	00 00 00 
  8036a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036a3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8036a6:	bf 05 00 00 00       	mov    $0x5,%edi
  8036ab:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  8036b2:	00 00 00 
  8036b5:	ff d0                	callq  *%rax
}
  8036b7:	c9                   	leaveq 
  8036b8:	c3                   	retq   

00000000008036b9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8036b9:	55                   	push   %rbp
  8036ba:	48 89 e5             	mov    %rsp,%rbp
  8036bd:	48 83 ec 10          	sub    $0x10,%rsp
  8036c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036c4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8036c7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036ce:	00 00 00 
  8036d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036d4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8036d6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036dd:	00 00 00 
  8036e0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036e3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8036e6:	bf 06 00 00 00       	mov    $0x6,%edi
  8036eb:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  8036f2:	00 00 00 
  8036f5:	ff d0                	callq  *%rax
}
  8036f7:	c9                   	leaveq 
  8036f8:	c3                   	retq   

00000000008036f9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8036f9:	55                   	push   %rbp
  8036fa:	48 89 e5             	mov    %rsp,%rbp
  8036fd:	48 83 ec 30          	sub    $0x30,%rsp
  803701:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803704:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803708:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80370b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80370e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803715:	00 00 00 
  803718:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80371b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80371d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803724:	00 00 00 
  803727:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80372a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80372d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803734:	00 00 00 
  803737:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80373a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80373d:	bf 07 00 00 00       	mov    $0x7,%edi
  803742:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  803749:	00 00 00 
  80374c:	ff d0                	callq  *%rax
  80374e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803751:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803755:	78 69                	js     8037c0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803757:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80375e:	7f 08                	jg     803768 <nsipc_recv+0x6f>
  803760:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803763:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803766:	7e 35                	jle    80379d <nsipc_recv+0xa4>
  803768:	48 b9 42 56 80 00 00 	movabs $0x805642,%rcx
  80376f:	00 00 00 
  803772:	48 ba 57 56 80 00 00 	movabs $0x805657,%rdx
  803779:	00 00 00 
  80377c:	be 61 00 00 00       	mov    $0x61,%esi
  803781:	48 bf 6c 56 80 00 00 	movabs $0x80566c,%rdi
  803788:	00 00 00 
  80378b:	b8 00 00 00 00       	mov    $0x0,%eax
  803790:	49 b8 08 0a 80 00 00 	movabs $0x800a08,%r8
  803797:	00 00 00 
  80379a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80379d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a0:	48 63 d0             	movslq %eax,%rdx
  8037a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a7:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8037ae:	00 00 00 
  8037b1:	48 89 c7             	mov    %rax,%rdi
  8037b4:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8037bb:	00 00 00 
  8037be:	ff d0                	callq  *%rax
	}

	return r;
  8037c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037c3:	c9                   	leaveq 
  8037c4:	c3                   	retq   

00000000008037c5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037c5:	55                   	push   %rbp
  8037c6:	48 89 e5             	mov    %rsp,%rbp
  8037c9:	48 83 ec 20          	sub    $0x20,%rsp
  8037cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037d4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8037d7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8037da:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037e1:	00 00 00 
  8037e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037e7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8037e9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8037f0:	7e 35                	jle    803827 <nsipc_send+0x62>
  8037f2:	48 b9 78 56 80 00 00 	movabs $0x805678,%rcx
  8037f9:	00 00 00 
  8037fc:	48 ba 57 56 80 00 00 	movabs $0x805657,%rdx
  803803:	00 00 00 
  803806:	be 6c 00 00 00       	mov    $0x6c,%esi
  80380b:	48 bf 6c 56 80 00 00 	movabs $0x80566c,%rdi
  803812:	00 00 00 
  803815:	b8 00 00 00 00       	mov    $0x0,%eax
  80381a:	49 b8 08 0a 80 00 00 	movabs $0x800a08,%r8
  803821:	00 00 00 
  803824:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803827:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80382a:	48 63 d0             	movslq %eax,%rdx
  80382d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803831:	48 89 c6             	mov    %rax,%rsi
  803834:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  80383b:	00 00 00 
  80383e:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  803845:	00 00 00 
  803848:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80384a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803851:	00 00 00 
  803854:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803857:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80385a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803861:	00 00 00 
  803864:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803867:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80386a:	bf 08 00 00 00       	mov    $0x8,%edi
  80386f:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
}
  80387b:	c9                   	leaveq 
  80387c:	c3                   	retq   

000000000080387d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80387d:	55                   	push   %rbp
  80387e:	48 89 e5             	mov    %rsp,%rbp
  803881:	48 83 ec 10          	sub    $0x10,%rsp
  803885:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803888:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80388b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80388e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803895:	00 00 00 
  803898:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80389b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80389d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038a4:	00 00 00 
  8038a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038aa:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8038ad:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038b4:	00 00 00 
  8038b7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8038ba:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8038bd:	bf 09 00 00 00       	mov    $0x9,%edi
  8038c2:	48 b8 84 34 80 00 00 	movabs $0x803484,%rax
  8038c9:	00 00 00 
  8038cc:	ff d0                	callq  *%rax
}
  8038ce:	c9                   	leaveq 
  8038cf:	c3                   	retq   

00000000008038d0 <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  8038d0:	55                   	push   %rbp
  8038d1:	48 89 e5             	mov    %rsp,%rbp
  8038d4:	48 83 ec 20          	sub    $0x20,%rsp
  8038d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  8038e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e4:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8038e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8038ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8038f4:	eb 62                	jmp    803958 <isfree+0x88>
		if (va >= (uintptr_t) mend
  8038f6:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8038fd:	00 00 00 
  803900:	48 8b 00             	mov    (%rax),%rax
  803903:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803907:	76 40                	jbe    803949 <isfree+0x79>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  803909:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390d:	48 89 c2             	mov    %rax,%rdx
  803910:	48 c1 ea 15          	shr    $0x15,%rdx
  803914:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80391b:	01 00 00 
  80391e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803922:	83 e0 01             	and    $0x1,%eax
  803925:	84 c0                	test   %al,%al
  803927:	74 27                	je     803950 <isfree+0x80>
  803929:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392d:	48 89 c2             	mov    %rax,%rdx
  803930:	48 c1 ea 0c          	shr    $0xc,%rdx
  803934:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80393b:	01 00 00 
  80393e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803942:	83 e0 01             	and    $0x1,%eax
  803945:	84 c0                	test   %al,%al
  803947:	74 07                	je     803950 <isfree+0x80>
			return 0;
  803949:	b8 00 00 00 00       	mov    $0x0,%eax
  80394e:	eb 17                	jmp    803967 <isfree+0x97>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803950:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803957:	00 
  803958:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803960:	72 94                	jb     8038f6 <isfree+0x26>
		if (va >= (uintptr_t) mend
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
			return 0;
	return 1;
  803962:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803967:	c9                   	leaveq 
  803968:	c3                   	retq   

0000000000803969 <malloc>:

void*
malloc(size_t n)
{
  803969:	55                   	push   %rbp
  80396a:	48 89 e5             	mov    %rsp,%rbp
  80396d:	48 83 ec 60          	sub    $0x60,%rsp
  803971:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803975:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80397c:	00 00 00 
  80397f:	48 8b 00             	mov    (%rax),%rax
  803982:	48 85 c0             	test   %rax,%rax
  803985:	75 1a                	jne    8039a1 <malloc+0x38>
		mptr = mbegin;
  803987:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  80398e:	00 00 00 
  803991:	48 8b 10             	mov    (%rax),%rdx
  803994:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80399b:	00 00 00 
  80399e:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  8039a1:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  8039a8:	00 
  8039a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ad:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8039b1:	48 01 d0             	add    %rdx,%rax
  8039b4:	48 83 e8 01          	sub    $0x1,%rax
  8039b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8039bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8039c5:	48 f7 75 f0          	divq   -0x10(%rbp)
  8039c9:	48 89 d0             	mov    %rdx,%rax
  8039cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039d0:	48 89 d1             	mov    %rdx,%rcx
  8039d3:	48 29 c1             	sub    %rax,%rcx
  8039d6:	48 89 c8             	mov    %rcx,%rax
  8039d9:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	if (n >= MAXMALLOC)
  8039dd:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  8039e4:	00 
  8039e5:	76 0a                	jbe    8039f1 <malloc+0x88>
		return 0;
  8039e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ec:	e9 f6 02 00 00       	jmpq   803ce7 <malloc+0x37e>

	if ((uintptr_t) mptr % PGSIZE){
  8039f1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8039f8:	00 00 00 
  8039fb:	48 8b 00             	mov    (%rax),%rax
  8039fe:	25 ff 0f 00 00       	and    $0xfff,%eax
  803a03:	48 85 c0             	test   %rax,%rax
  803a06:	0f 84 12 01 00 00    	je     803b1e <malloc+0x1b5>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  803a0c:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  803a13:	00 
  803a14:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803a1b:	00 00 00 
  803a1e:	48 8b 00             	mov    (%rax),%rax
  803a21:	48 03 45 e0          	add    -0x20(%rbp),%rax
  803a25:	48 83 e8 01          	sub    $0x1,%rax
  803a29:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a31:	ba 00 00 00 00       	mov    $0x0,%edx
  803a36:	48 f7 75 e0          	divq   -0x20(%rbp)
  803a3a:	48 89 d0             	mov    %rdx,%rax
  803a3d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a41:	48 89 d1             	mov    %rdx,%rcx
  803a44:	48 29 c1             	sub    %rax,%rcx
  803a47:	48 89 c8             	mov    %rcx,%rax
  803a4a:	48 83 e8 04          	sub    $0x4,%rax
  803a4e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  803a52:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803a59:	00 00 00 
  803a5c:	48 8b 00             	mov    (%rax),%rax
  803a5f:	48 89 c1             	mov    %rax,%rcx
  803a62:	48 c1 e9 0c          	shr    $0xc,%rcx
  803a66:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803a6d:	00 00 00 
  803a70:	48 8b 00             	mov    (%rax),%rax
  803a73:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803a77:	48 83 c2 03          	add    $0x3,%rdx
  803a7b:	48 01 d0             	add    %rdx,%rax
  803a7e:	48 c1 e8 0c          	shr    $0xc,%rax
  803a82:	48 39 c1             	cmp    %rax,%rcx
  803a85:	75 4a                	jne    803ad1 <malloc+0x168>
			(*ref)++;
  803a87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a8b:	8b 00                	mov    (%rax),%eax
  803a8d:	8d 50 01             	lea    0x1(%rax),%edx
  803a90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a94:	89 10                	mov    %edx,(%rax)
			v = mptr;
  803a96:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803a9d:	00 00 00 
  803aa0:	48 8b 00             	mov    (%rax),%rax
  803aa3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  803aa7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803aae:	00 00 00 
  803ab1:	48 8b 00             	mov    (%rax),%rax
  803ab4:	48 89 c2             	mov    %rax,%rdx
  803ab7:	48 03 55 a8          	add    -0x58(%rbp),%rdx
  803abb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ac2:	00 00 00 
  803ac5:	48 89 10             	mov    %rdx,(%rax)
			return v;
  803ac8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803acc:	e9 16 02 00 00       	jmpq   803ce7 <malloc+0x37e>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  803ad1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ad8:	00 00 00 
  803adb:	48 8b 00             	mov    (%rax),%rax
  803ade:	48 89 c7             	mov    %rax,%rdi
  803ae1:	48 b8 e9 3c 80 00 00 	movabs $0x803ce9,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  803aed:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803af4:	00 00 00 
  803af7:	48 8b 00             	mov    (%rax),%rax
  803afa:	48 05 00 10 00 00    	add    $0x1000,%rax
  803b00:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803b04:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b08:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803b0e:	48 89 c2             	mov    %rax,%rdx
  803b11:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b18:	00 00 00 
  803b1b:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  803b1e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  803b25:	eb 01                	jmp    803b28 <malloc+0x1bf>
		if (mptr == mend) {
			mptr = mbegin;
			if (++nwrap == 2)
				return 0;	/* out of address space */
		}
	}
  803b27:	90                   	nop
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  803b28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b2c:	48 8d 50 04          	lea    0x4(%rax),%rdx
  803b30:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b37:	00 00 00 
  803b3a:	48 8b 00             	mov    (%rax),%rax
  803b3d:	48 89 d6             	mov    %rdx,%rsi
  803b40:	48 89 c7             	mov    %rax,%rdi
  803b43:	48 b8 d0 38 80 00 00 	movabs $0x8038d0,%rax
  803b4a:	00 00 00 
  803b4d:	ff d0                	callq  *%rax
  803b4f:	85 c0                	test   %eax,%eax
  803b51:	75 72                	jne    803bc5 <malloc+0x25c>
			break;
		mptr += PGSIZE;
  803b53:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b5a:	00 00 00 
  803b5d:	48 8b 00             	mov    (%rax),%rax
  803b60:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  803b67:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b6e:	00 00 00 
  803b71:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  803b74:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b7b:	00 00 00 
  803b7e:	48 8b 10             	mov    (%rax),%rdx
  803b81:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803b88:	00 00 00 
  803b8b:	48 8b 00             	mov    (%rax),%rax
  803b8e:	48 39 c2             	cmp    %rax,%rdx
  803b91:	75 94                	jne    803b27 <malloc+0x1be>
			mptr = mbegin;
  803b93:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803b9a:	00 00 00 
  803b9d:	48 8b 10             	mov    (%rax),%rdx
  803ba0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ba7:	00 00 00 
  803baa:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  803bad:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  803bb1:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  803bb5:	0f 85 6c ff ff ff    	jne    803b27 <malloc+0x1be>
				return 0;	/* out of address space */
  803bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc0:	e9 22 01 00 00       	jmpq   803ce7 <malloc+0x37e>
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
  803bc5:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803bc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bcd:	e9 a1 00 00 00       	jmpq   803c73 <malloc+0x30a>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  803bd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd5:	05 00 10 00 00       	add    $0x1000,%eax
  803bda:	48 98                	cltq   
  803bdc:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803be0:	48 83 c2 04          	add    $0x4,%rdx
  803be4:	48 39 d0             	cmp    %rdx,%rax
  803be7:	73 07                	jae    803bf0 <malloc+0x287>
  803be9:	b8 00 04 00 00       	mov    $0x400,%eax
  803bee:	eb 05                	jmp    803bf5 <malloc+0x28c>
  803bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf5:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  803bf8:	8b 45 bc             	mov    -0x44(%rbp),%eax
  803bfb:	89 c2                	mov    %eax,%edx
  803bfd:	83 ca 07             	or     $0x7,%edx
  803c00:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c07:	00 00 00 
  803c0a:	48 8b 08             	mov    (%rax),%rcx
  803c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c10:	48 98                	cltq   
  803c12:	48 01 c8             	add    %rcx,%rax
  803c15:	48 89 c6             	mov    %rax,%rsi
  803c18:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1d:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  803c24:	00 00 00 
  803c27:	ff d0                	callq  *%rax
  803c29:	85 c0                	test   %eax,%eax
  803c2b:	79 3f                	jns    803c6c <malloc+0x303>
			for (; i >= 0; i -= PGSIZE)
  803c2d:	eb 30                	jmp    803c5f <malloc+0x2f6>
				sys_page_unmap(0, mptr + i);
  803c2f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c36:	00 00 00 
  803c39:	48 8b 10             	mov    (%rax),%rdx
  803c3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c3f:	48 98                	cltq   
  803c41:	48 01 d0             	add    %rdx,%rax
  803c44:	48 89 c6             	mov    %rax,%rsi
  803c47:	bf 00 00 00 00       	mov    $0x0,%edi
  803c4c:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  803c53:	00 00 00 
  803c56:	ff d0                	callq  *%rax
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  803c58:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  803c5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c63:	79 ca                	jns    803c2f <malloc+0x2c6>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  803c65:	b8 00 00 00 00       	mov    $0x0,%eax
  803c6a:	eb 7b                	jmp    803ce7 <malloc+0x37e>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803c6c:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c76:	48 98                	cltq   
  803c78:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803c7c:	48 83 c2 04          	add    $0x4,%rdx
  803c80:	48 39 d0             	cmp    %rdx,%rax
  803c83:	0f 82 49 ff ff ff    	jb     803bd2 <malloc+0x269>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  803c89:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803c90:	00 00 00 
  803c93:	48 8b 00             	mov    (%rax),%rax
  803c96:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c99:	48 63 d2             	movslq %edx,%rdx
  803c9c:	48 83 ea 04          	sub    $0x4,%rdx
  803ca0:	48 01 d0             	add    %rdx,%rax
  803ca3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  803ca7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cab:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  803cb1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803cb8:	00 00 00 
  803cbb:	48 8b 00             	mov    (%rax),%rax
  803cbe:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  803cc2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803cc9:	00 00 00 
  803ccc:	48 8b 00             	mov    (%rax),%rax
  803ccf:	48 89 c2             	mov    %rax,%rdx
  803cd2:	48 03 55 a8          	add    -0x58(%rbp),%rdx
  803cd6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803cdd:	00 00 00 
  803ce0:	48 89 10             	mov    %rdx,(%rax)
	return v;
  803ce3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  803ce7:	c9                   	leaveq 
  803ce8:	c3                   	retq   

0000000000803ce9 <free>:

void
free(void *v)
{
  803ce9:	55                   	push   %rbp
  803cea:	48 89 e5             	mov    %rsp,%rbp
  803ced:	48 83 ec 30          	sub    $0x30,%rsp
  803cf1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  803cf5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cfa:	0f 84 56 01 00 00    	je     803e56 <free+0x16d>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  803d00:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803d07:	00 00 00 
  803d0a:	48 8b 00             	mov    (%rax),%rax
  803d0d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803d11:	77 13                	ja     803d26 <free+0x3d>
  803d13:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803d1a:	00 00 00 
  803d1d:	48 8b 00             	mov    (%rax),%rax
  803d20:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803d24:	72 35                	jb     803d5b <free+0x72>
  803d26:	48 b9 88 56 80 00 00 	movabs $0x805688,%rcx
  803d2d:	00 00 00 
  803d30:	48 ba b6 56 80 00 00 	movabs $0x8056b6,%rdx
  803d37:	00 00 00 
  803d3a:	be 7a 00 00 00       	mov    $0x7a,%esi
  803d3f:	48 bf cb 56 80 00 00 	movabs $0x8056cb,%rdi
  803d46:	00 00 00 
  803d49:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4e:	49 b8 08 0a 80 00 00 	movabs $0x800a08,%r8
  803d55:	00 00 00 
  803d58:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  803d5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  803d63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d67:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803d6d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  803d71:	eb 7b                	jmp    803dee <free+0x105>
		sys_page_unmap(0, c);
  803d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d77:	48 89 c6             	mov    %rax,%rsi
  803d7a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7f:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
		c += PGSIZE;
  803d8b:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803d92:	00 
		assert(mbegin <= c && c < mend);
  803d93:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803d9a:	00 00 00 
  803d9d:	48 8b 00             	mov    (%rax),%rax
  803da0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803da4:	77 13                	ja     803db9 <free+0xd0>
  803da6:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803dad:	00 00 00 
  803db0:	48 8b 00             	mov    (%rax),%rax
  803db3:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803db7:	72 35                	jb     803dee <free+0x105>
  803db9:	48 b9 d8 56 80 00 00 	movabs $0x8056d8,%rcx
  803dc0:	00 00 00 
  803dc3:	48 ba b6 56 80 00 00 	movabs $0x8056b6,%rdx
  803dca:	00 00 00 
  803dcd:	be 81 00 00 00       	mov    $0x81,%esi
  803dd2:	48 bf cb 56 80 00 00 	movabs $0x8056cb,%rdi
  803dd9:	00 00 00 
  803ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  803de1:	49 b8 08 0a 80 00 00 	movabs $0x800a08,%r8
  803de8:	00 00 00 
  803deb:	41 ff d0             	callq  *%r8
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  803dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df2:	48 89 c2             	mov    %rax,%rdx
  803df5:	48 c1 ea 0c          	shr    $0xc,%rdx
  803df9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e00:	01 00 00 
  803e03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e07:	25 00 04 00 00       	and    $0x400,%eax
  803e0c:	48 85 c0             	test   %rax,%rax
  803e0f:	0f 85 5e ff ff ff    	jne    803d73 <free+0x8a>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  803e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e19:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  803e1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  803e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e27:	8b 00                	mov    (%rax),%eax
  803e29:	8d 50 ff             	lea    -0x1(%rax),%edx
  803e2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e30:	89 10                	mov    %edx,(%rax)
  803e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e36:	8b 00                	mov    (%rax),%eax
  803e38:	85 c0                	test   %eax,%eax
  803e3a:	75 1b                	jne    803e57 <free+0x16e>
		sys_page_unmap(0, c);
  803e3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e40:	48 89 c6             	mov    %rax,%rsi
  803e43:	bf 00 00 00 00       	mov    $0x0,%edi
  803e48:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  803e4f:	00 00 00 
  803e52:	ff d0                	callq  *%rax
  803e54:	eb 01                	jmp    803e57 <free+0x16e>
{
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
		return;
  803e56:	90                   	nop
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
		sys_page_unmap(0, c);
}
  803e57:	c9                   	leaveq 
  803e58:	c3                   	retq   
  803e59:	00 00                	add    %al,(%rax)
	...

0000000000803e5c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e5c:	55                   	push   %rbp
  803e5d:	48 89 e5             	mov    %rsp,%rbp
  803e60:	53                   	push   %rbx
  803e61:	48 83 ec 38          	sub    $0x38,%rsp
  803e65:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e69:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e6d:	48 89 c7             	mov    %rax,%rdi
  803e70:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803e77:	00 00 00 
  803e7a:	ff d0                	callq  *%rax
  803e7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e83:	0f 88 bf 01 00 00    	js     804048 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e8d:	ba 07 04 00 00       	mov    $0x407,%edx
  803e92:	48 89 c6             	mov    %rax,%rsi
  803e95:	bf 00 00 00 00       	mov    $0x0,%edi
  803e9a:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  803ea1:	00 00 00 
  803ea4:	ff d0                	callq  *%rax
  803ea6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ea9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ead:	0f 88 95 01 00 00    	js     804048 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803eb3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803eb7:	48 89 c7             	mov    %rax,%rdi
  803eba:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803ec1:	00 00 00 
  803ec4:	ff d0                	callq  *%rax
  803ec6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ec9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ecd:	0f 88 5d 01 00 00    	js     804030 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ed3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ed7:	ba 07 04 00 00       	mov    $0x407,%edx
  803edc:	48 89 c6             	mov    %rax,%rsi
  803edf:	bf 00 00 00 00       	mov    $0x0,%edi
  803ee4:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  803eeb:	00 00 00 
  803eee:	ff d0                	callq  *%rax
  803ef0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ef3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ef7:	0f 88 33 01 00 00    	js     804030 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803efd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f01:	48 89 c7             	mov    %rax,%rdi
  803f04:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  803f0b:	00 00 00 
  803f0e:	ff d0                	callq  *%rax
  803f10:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f18:	ba 07 04 00 00       	mov    $0x407,%edx
  803f1d:	48 89 c6             	mov    %rax,%rsi
  803f20:	bf 00 00 00 00       	mov    $0x0,%edi
  803f25:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  803f2c:	00 00 00 
  803f2f:	ff d0                	callq  *%rax
  803f31:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f34:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f38:	0f 88 d9 00 00 00    	js     804017 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f42:	48 89 c7             	mov    %rax,%rdi
  803f45:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
  803f51:	48 89 c2             	mov    %rax,%rdx
  803f54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f58:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f5e:	48 89 d1             	mov    %rdx,%rcx
  803f61:	ba 00 00 00 00       	mov    $0x0,%edx
  803f66:	48 89 c6             	mov    %rax,%rsi
  803f69:	bf 00 00 00 00       	mov    $0x0,%edi
  803f6e:	48 b8 9c 21 80 00 00 	movabs $0x80219c,%rax
  803f75:	00 00 00 
  803f78:	ff d0                	callq  *%rax
  803f7a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f81:	78 79                	js     803ffc <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f87:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  803f8e:	00 00 00 
  803f91:	8b 12                	mov    (%rdx),%edx
  803f93:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803fa0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fa4:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  803fab:	00 00 00 
  803fae:	8b 12                	mov    (%rdx),%edx
  803fb0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803fb2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fb6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803fbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fc1:	48 89 c7             	mov    %rax,%rdi
  803fc4:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  803fcb:	00 00 00 
  803fce:	ff d0                	callq  *%rax
  803fd0:	89 c2                	mov    %eax,%edx
  803fd2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fd6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803fd8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fdc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803fe0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fe4:	48 89 c7             	mov    %rax,%rdi
  803fe7:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  803fee:	00 00 00 
  803ff1:	ff d0                	callq  *%rax
  803ff3:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  803ffa:	eb 4f                	jmp    80404b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803ffc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803ffd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804001:	48 89 c6             	mov    %rax,%rsi
  804004:	bf 00 00 00 00       	mov    $0x0,%edi
  804009:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  804010:	00 00 00 
  804013:	ff d0                	callq  *%rax
  804015:	eb 01                	jmp    804018 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804017:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804018:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80401c:	48 89 c6             	mov    %rax,%rsi
  80401f:	bf 00 00 00 00       	mov    $0x0,%edi
  804024:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  80402b:	00 00 00 
  80402e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804030:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804034:	48 89 c6             	mov    %rax,%rsi
  804037:	bf 00 00 00 00       	mov    $0x0,%edi
  80403c:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  804043:	00 00 00 
  804046:	ff d0                	callq  *%rax
err:
	return r;
  804048:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80404b:	48 83 c4 38          	add    $0x38,%rsp
  80404f:	5b                   	pop    %rbx
  804050:	5d                   	pop    %rbp
  804051:	c3                   	retq   

0000000000804052 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804052:	55                   	push   %rbp
  804053:	48 89 e5             	mov    %rsp,%rbp
  804056:	53                   	push   %rbx
  804057:	48 83 ec 28          	sub    $0x28,%rsp
  80405b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80405f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804063:	eb 01                	jmp    804066 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  804065:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804066:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80406d:	00 00 00 
  804070:	48 8b 00             	mov    (%rax),%rax
  804073:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804079:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80407c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804080:	48 89 c7             	mov    %rax,%rdi
  804083:	48 b8 fc 48 80 00 00 	movabs $0x8048fc,%rax
  80408a:	00 00 00 
  80408d:	ff d0                	callq  *%rax
  80408f:	89 c3                	mov    %eax,%ebx
  804091:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804095:	48 89 c7             	mov    %rax,%rdi
  804098:	48 b8 fc 48 80 00 00 	movabs $0x8048fc,%rax
  80409f:	00 00 00 
  8040a2:	ff d0                	callq  *%rax
  8040a4:	39 c3                	cmp    %eax,%ebx
  8040a6:	0f 94 c0             	sete   %al
  8040a9:	0f b6 c0             	movzbl %al,%eax
  8040ac:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8040af:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8040b6:	00 00 00 
  8040b9:	48 8b 00             	mov    (%rax),%rax
  8040bc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040c2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8040c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040c8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040cb:	75 0a                	jne    8040d7 <_pipeisclosed+0x85>
			return ret;
  8040cd:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8040d0:	48 83 c4 28          	add    $0x28,%rsp
  8040d4:	5b                   	pop    %rbx
  8040d5:	5d                   	pop    %rbp
  8040d6:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8040d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040da:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040dd:	74 86                	je     804065 <_pipeisclosed+0x13>
  8040df:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8040e3:	75 80                	jne    804065 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8040e5:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8040ec:	00 00 00 
  8040ef:	48 8b 00             	mov    (%rax),%rax
  8040f2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8040f8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8040fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040fe:	89 c6                	mov    %eax,%esi
  804100:	48 bf f5 56 80 00 00 	movabs $0x8056f5,%rdi
  804107:	00 00 00 
  80410a:	b8 00 00 00 00       	mov    $0x0,%eax
  80410f:	49 b8 43 0c 80 00 00 	movabs $0x800c43,%r8
  804116:	00 00 00 
  804119:	41 ff d0             	callq  *%r8
	}
  80411c:	e9 44 ff ff ff       	jmpq   804065 <_pipeisclosed+0x13>

0000000000804121 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804121:	55                   	push   %rbp
  804122:	48 89 e5             	mov    %rsp,%rbp
  804125:	48 83 ec 30          	sub    $0x30,%rsp
  804129:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80412c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804130:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804133:	48 89 d6             	mov    %rdx,%rsi
  804136:	89 c7                	mov    %eax,%edi
  804138:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  80413f:	00 00 00 
  804142:	ff d0                	callq  *%rax
  804144:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804147:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80414b:	79 05                	jns    804152 <pipeisclosed+0x31>
		return r;
  80414d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804150:	eb 31                	jmp    804183 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804156:	48 89 c7             	mov    %rax,%rdi
  804159:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  804160:	00 00 00 
  804163:	ff d0                	callq  *%rax
  804165:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80416d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804171:	48 89 d6             	mov    %rdx,%rsi
  804174:	48 89 c7             	mov    %rax,%rdi
  804177:	48 b8 52 40 80 00 00 	movabs $0x804052,%rax
  80417e:	00 00 00 
  804181:	ff d0                	callq  *%rax
}
  804183:	c9                   	leaveq 
  804184:	c3                   	retq   

0000000000804185 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804185:	55                   	push   %rbp
  804186:	48 89 e5             	mov    %rsp,%rbp
  804189:	48 83 ec 40          	sub    $0x40,%rsp
  80418d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804191:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804195:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804199:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80419d:	48 89 c7             	mov    %rax,%rdi
  8041a0:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  8041a7:	00 00 00 
  8041aa:	ff d0                	callq  *%rax
  8041ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041b8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041bf:	00 
  8041c0:	e9 97 00 00 00       	jmpq   80425c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8041c5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8041ca:	74 09                	je     8041d5 <devpipe_read+0x50>
				return i;
  8041cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d0:	e9 95 00 00 00       	jmpq   80426a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8041d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041dd:	48 89 d6             	mov    %rdx,%rsi
  8041e0:	48 89 c7             	mov    %rax,%rdi
  8041e3:	48 b8 52 40 80 00 00 	movabs $0x804052,%rax
  8041ea:	00 00 00 
  8041ed:	ff d0                	callq  *%rax
  8041ef:	85 c0                	test   %eax,%eax
  8041f1:	74 07                	je     8041fa <devpipe_read+0x75>
				return 0;
  8041f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f8:	eb 70                	jmp    80426a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8041fa:	48 b8 0e 21 80 00 00 	movabs $0x80210e,%rax
  804201:	00 00 00 
  804204:	ff d0                	callq  *%rax
  804206:	eb 01                	jmp    804209 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804208:	90                   	nop
  804209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80420d:	8b 10                	mov    (%rax),%edx
  80420f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804213:	8b 40 04             	mov    0x4(%rax),%eax
  804216:	39 c2                	cmp    %eax,%edx
  804218:	74 ab                	je     8041c5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80421a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80421e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804222:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80422a:	8b 00                	mov    (%rax),%eax
  80422c:	89 c2                	mov    %eax,%edx
  80422e:	c1 fa 1f             	sar    $0x1f,%edx
  804231:	c1 ea 1b             	shr    $0x1b,%edx
  804234:	01 d0                	add    %edx,%eax
  804236:	83 e0 1f             	and    $0x1f,%eax
  804239:	29 d0                	sub    %edx,%eax
  80423b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80423f:	48 98                	cltq   
  804241:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804246:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424c:	8b 00                	mov    (%rax),%eax
  80424e:	8d 50 01             	lea    0x1(%rax),%edx
  804251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804255:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804257:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80425c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804260:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804264:	72 a2                	jb     804208 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80426a:	c9                   	leaveq 
  80426b:	c3                   	retq   

000000000080426c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80426c:	55                   	push   %rbp
  80426d:	48 89 e5             	mov    %rsp,%rbp
  804270:	48 83 ec 40          	sub    $0x40,%rsp
  804274:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804278:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80427c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804280:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804284:	48 89 c7             	mov    %rax,%rdi
  804287:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  80428e:	00 00 00 
  804291:	ff d0                	callq  *%rax
  804293:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804297:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80429b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80429f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042a6:	00 
  8042a7:	e9 93 00 00 00       	jmpq   80433f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8042ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b4:	48 89 d6             	mov    %rdx,%rsi
  8042b7:	48 89 c7             	mov    %rax,%rdi
  8042ba:	48 b8 52 40 80 00 00 	movabs $0x804052,%rax
  8042c1:	00 00 00 
  8042c4:	ff d0                	callq  *%rax
  8042c6:	85 c0                	test   %eax,%eax
  8042c8:	74 07                	je     8042d1 <devpipe_write+0x65>
				return 0;
  8042ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8042cf:	eb 7c                	jmp    80434d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8042d1:	48 b8 0e 21 80 00 00 	movabs $0x80210e,%rax
  8042d8:	00 00 00 
  8042db:	ff d0                	callq  *%rax
  8042dd:	eb 01                	jmp    8042e0 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8042df:	90                   	nop
  8042e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e4:	8b 40 04             	mov    0x4(%rax),%eax
  8042e7:	48 63 d0             	movslq %eax,%rdx
  8042ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ee:	8b 00                	mov    (%rax),%eax
  8042f0:	48 98                	cltq   
  8042f2:	48 83 c0 20          	add    $0x20,%rax
  8042f6:	48 39 c2             	cmp    %rax,%rdx
  8042f9:	73 b1                	jae    8042ac <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8042fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ff:	8b 40 04             	mov    0x4(%rax),%eax
  804302:	89 c2                	mov    %eax,%edx
  804304:	c1 fa 1f             	sar    $0x1f,%edx
  804307:	c1 ea 1b             	shr    $0x1b,%edx
  80430a:	01 d0                	add    %edx,%eax
  80430c:	83 e0 1f             	and    $0x1f,%eax
  80430f:	29 d0                	sub    %edx,%eax
  804311:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804315:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804319:	48 01 ca             	add    %rcx,%rdx
  80431c:	0f b6 0a             	movzbl (%rdx),%ecx
  80431f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804323:	48 98                	cltq   
  804325:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80432d:	8b 40 04             	mov    0x4(%rax),%eax
  804330:	8d 50 01             	lea    0x1(%rax),%edx
  804333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804337:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80433a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80433f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804343:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804347:	72 96                	jb     8042df <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80434d:	c9                   	leaveq 
  80434e:	c3                   	retq   

000000000080434f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80434f:	55                   	push   %rbp
  804350:	48 89 e5             	mov    %rsp,%rbp
  804353:	48 83 ec 20          	sub    $0x20,%rsp
  804357:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80435b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80435f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804363:	48 89 c7             	mov    %rax,%rdi
  804366:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  80436d:	00 00 00 
  804370:	ff d0                	callq  *%rax
  804372:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80437a:	48 be 08 57 80 00 00 	movabs $0x805708,%rsi
  804381:	00 00 00 
  804384:	48 89 c7             	mov    %rax,%rdi
  804387:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  80438e:	00 00 00 
  804391:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804397:	8b 50 04             	mov    0x4(%rax),%edx
  80439a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80439e:	8b 00                	mov    (%rax),%eax
  8043a0:	29 c2                	sub    %eax,%edx
  8043a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043a6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8043ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8043b7:	00 00 00 
	stat->st_dev = &devpipe;
  8043ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043be:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  8043c5:	00 00 00 
  8043c8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8043cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043d4:	c9                   	leaveq 
  8043d5:	c3                   	retq   

00000000008043d6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8043d6:	55                   	push   %rbp
  8043d7:	48 89 e5             	mov    %rsp,%rbp
  8043da:	48 83 ec 10          	sub    $0x10,%rsp
  8043de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8043e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e6:	48 89 c6             	mov    %rax,%rsi
  8043e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ee:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  8043f5:	00 00 00 
  8043f8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8043fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043fe:	48 89 c7             	mov    %rax,%rdi
  804401:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  804408:	00 00 00 
  80440b:	ff d0                	callq  *%rax
  80440d:	48 89 c6             	mov    %rax,%rsi
  804410:	bf 00 00 00 00       	mov    $0x0,%edi
  804415:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  80441c:	00 00 00 
  80441f:	ff d0                	callq  *%rax
}
  804421:	c9                   	leaveq 
  804422:	c3                   	retq   
	...

0000000000804424 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804424:	55                   	push   %rbp
  804425:	48 89 e5             	mov    %rsp,%rbp
  804428:	48 83 ec 20          	sub    $0x20,%rsp
  80442c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80442f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804432:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804435:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804439:	be 01 00 00 00       	mov    $0x1,%esi
  80443e:	48 89 c7             	mov    %rax,%rdi
  804441:	48 b8 04 20 80 00 00 	movabs $0x802004,%rax
  804448:	00 00 00 
  80444b:	ff d0                	callq  *%rax
}
  80444d:	c9                   	leaveq 
  80444e:	c3                   	retq   

000000000080444f <getchar>:

int
getchar(void)
{
  80444f:	55                   	push   %rbp
  804450:	48 89 e5             	mov    %rsp,%rbp
  804453:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804457:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80445b:	ba 01 00 00 00       	mov    $0x1,%edx
  804460:	48 89 c6             	mov    %rax,%rsi
  804463:	bf 00 00 00 00       	mov    $0x0,%edi
  804468:	48 b8 b4 29 80 00 00 	movabs $0x8029b4,%rax
  80446f:	00 00 00 
  804472:	ff d0                	callq  *%rax
  804474:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804477:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80447b:	79 05                	jns    804482 <getchar+0x33>
		return r;
  80447d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804480:	eb 14                	jmp    804496 <getchar+0x47>
	if (r < 1)
  804482:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804486:	7f 07                	jg     80448f <getchar+0x40>
		return -E_EOF;
  804488:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80448d:	eb 07                	jmp    804496 <getchar+0x47>
	return c;
  80448f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804493:	0f b6 c0             	movzbl %al,%eax
}
  804496:	c9                   	leaveq 
  804497:	c3                   	retq   

0000000000804498 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804498:	55                   	push   %rbp
  804499:	48 89 e5             	mov    %rsp,%rbp
  80449c:	48 83 ec 20          	sub    $0x20,%rsp
  8044a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8044a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8044a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044aa:	48 89 d6             	mov    %rdx,%rsi
  8044ad:	89 c7                	mov    %eax,%edi
  8044af:	48 b8 82 25 80 00 00 	movabs $0x802582,%rax
  8044b6:	00 00 00 
  8044b9:	ff d0                	callq  *%rax
  8044bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044c2:	79 05                	jns    8044c9 <iscons+0x31>
		return r;
  8044c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c7:	eb 1a                	jmp    8044e3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8044c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044cd:	8b 10                	mov    (%rax),%edx
  8044cf:	48 b8 80 71 80 00 00 	movabs $0x807180,%rax
  8044d6:	00 00 00 
  8044d9:	8b 00                	mov    (%rax),%eax
  8044db:	39 c2                	cmp    %eax,%edx
  8044dd:	0f 94 c0             	sete   %al
  8044e0:	0f b6 c0             	movzbl %al,%eax
}
  8044e3:	c9                   	leaveq 
  8044e4:	c3                   	retq   

00000000008044e5 <opencons>:

int
opencons(void)
{
  8044e5:	55                   	push   %rbp
  8044e6:	48 89 e5             	mov    %rsp,%rbp
  8044e9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8044ed:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8044f1:	48 89 c7             	mov    %rax,%rdi
  8044f4:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8044fb:	00 00 00 
  8044fe:	ff d0                	callq  *%rax
  804500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804507:	79 05                	jns    80450e <opencons+0x29>
		return r;
  804509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80450c:	eb 5b                	jmp    804569 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80450e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804512:	ba 07 04 00 00       	mov    $0x407,%edx
  804517:	48 89 c6             	mov    %rax,%rsi
  80451a:	bf 00 00 00 00       	mov    $0x0,%edi
  80451f:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  804526:	00 00 00 
  804529:	ff d0                	callq  *%rax
  80452b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80452e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804532:	79 05                	jns    804539 <opencons+0x54>
		return r;
  804534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804537:	eb 30                	jmp    804569 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80453d:	48 ba 80 71 80 00 00 	movabs $0x807180,%rdx
  804544:	00 00 00 
  804547:	8b 12                	mov    (%rdx),%edx
  804549:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80454b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80455a:	48 89 c7             	mov    %rax,%rdi
  80455d:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  804564:	00 00 00 
  804567:	ff d0                	callq  *%rax
}
  804569:	c9                   	leaveq 
  80456a:	c3                   	retq   

000000000080456b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80456b:	55                   	push   %rbp
  80456c:	48 89 e5             	mov    %rsp,%rbp
  80456f:	48 83 ec 30          	sub    $0x30,%rsp
  804573:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804577:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80457b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80457f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804584:	75 13                	jne    804599 <devcons_read+0x2e>
		return 0;
  804586:	b8 00 00 00 00       	mov    $0x0,%eax
  80458b:	eb 49                	jmp    8045d6 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80458d:	48 b8 0e 21 80 00 00 	movabs $0x80210e,%rax
  804594:	00 00 00 
  804597:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804599:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  8045a0:	00 00 00 
  8045a3:	ff d0                	callq  *%rax
  8045a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ac:	74 df                	je     80458d <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8045ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b2:	79 05                	jns    8045b9 <devcons_read+0x4e>
		return c;
  8045b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b7:	eb 1d                	jmp    8045d6 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8045b9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8045bd:	75 07                	jne    8045c6 <devcons_read+0x5b>
		return 0;
  8045bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c4:	eb 10                	jmp    8045d6 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8045c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c9:	89 c2                	mov    %eax,%edx
  8045cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045cf:	88 10                	mov    %dl,(%rax)
	return 1;
  8045d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8045d6:	c9                   	leaveq 
  8045d7:	c3                   	retq   

00000000008045d8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045d8:	55                   	push   %rbp
  8045d9:	48 89 e5             	mov    %rsp,%rbp
  8045dc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8045e3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8045ea:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8045f1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045ff:	eb 77                	jmp    804678 <devcons_write+0xa0>
		m = n - tot;
  804601:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804608:	89 c2                	mov    %eax,%edx
  80460a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80460d:	89 d1                	mov    %edx,%ecx
  80460f:	29 c1                	sub    %eax,%ecx
  804611:	89 c8                	mov    %ecx,%eax
  804613:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804616:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804619:	83 f8 7f             	cmp    $0x7f,%eax
  80461c:	76 07                	jbe    804625 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80461e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804625:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804628:	48 63 d0             	movslq %eax,%rdx
  80462b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80462e:	48 98                	cltq   
  804630:	48 89 c1             	mov    %rax,%rcx
  804633:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80463a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804641:	48 89 ce             	mov    %rcx,%rsi
  804644:	48 89 c7             	mov    %rax,%rdi
  804647:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  80464e:	00 00 00 
  804651:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804653:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804656:	48 63 d0             	movslq %eax,%rdx
  804659:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804660:	48 89 d6             	mov    %rdx,%rsi
  804663:	48 89 c7             	mov    %rax,%rdi
  804666:	48 b8 04 20 80 00 00 	movabs $0x802004,%rax
  80466d:	00 00 00 
  804670:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804672:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804675:	01 45 fc             	add    %eax,-0x4(%rbp)
  804678:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80467b:	48 98                	cltq   
  80467d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804684:	0f 82 77 ff ff ff    	jb     804601 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80468a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80468d:	c9                   	leaveq 
  80468e:	c3                   	retq   

000000000080468f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80468f:	55                   	push   %rbp
  804690:	48 89 e5             	mov    %rsp,%rbp
  804693:	48 83 ec 08          	sub    $0x8,%rsp
  804697:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80469b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046a0:	c9                   	leaveq 
  8046a1:	c3                   	retq   

00000000008046a2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8046a2:	55                   	push   %rbp
  8046a3:	48 89 e5             	mov    %rsp,%rbp
  8046a6:	48 83 ec 10          	sub    $0x10,%rsp
  8046aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8046b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b6:	48 be 14 57 80 00 00 	movabs $0x805714,%rsi
  8046bd:	00 00 00 
  8046c0:	48 89 c7             	mov    %rax,%rdi
  8046c3:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  8046ca:	00 00 00 
  8046cd:	ff d0                	callq  *%rax
	return 0;
  8046cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046d4:	c9                   	leaveq 
  8046d5:	c3                   	retq   
	...

00000000008046d8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8046d8:	55                   	push   %rbp
  8046d9:	48 89 e5             	mov    %rsp,%rbp
  8046dc:	48 83 ec 30          	sub    $0x30,%rsp
  8046e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8046ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8046f3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8046f8:	74 18                	je     804712 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8046fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046fe:	48 89 c7             	mov    %rax,%rdi
  804701:	48 b8 75 23 80 00 00 	movabs $0x802375,%rax
  804708:	00 00 00 
  80470b:	ff d0                	callq  *%rax
  80470d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804710:	eb 19                	jmp    80472b <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  804712:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  804719:	00 00 00 
  80471c:	48 b8 75 23 80 00 00 	movabs $0x802375,%rax
  804723:	00 00 00 
  804726:	ff d0                	callq  *%rax
  804728:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  80472b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80472f:	79 39                	jns    80476a <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804731:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804736:	75 08                	jne    804740 <ipc_recv+0x68>
  804738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80473c:	8b 00                	mov    (%rax),%eax
  80473e:	eb 05                	jmp    804745 <ipc_recv+0x6d>
  804740:	b8 00 00 00 00       	mov    $0x0,%eax
  804745:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804749:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  80474b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804750:	75 08                	jne    80475a <ipc_recv+0x82>
  804752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804756:	8b 00                	mov    (%rax),%eax
  804758:	eb 05                	jmp    80475f <ipc_recv+0x87>
  80475a:	b8 00 00 00 00       	mov    $0x0,%eax
  80475f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804763:	89 02                	mov    %eax,(%rdx)
		return r;
  804765:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804768:	eb 53                	jmp    8047bd <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80476a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80476f:	74 19                	je     80478a <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804771:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804778:	00 00 00 
  80477b:	48 8b 00             	mov    (%rax),%rax
  80477e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804788:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  80478a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80478f:	74 19                	je     8047aa <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  804791:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804798:	00 00 00 
  80479b:	48 8b 00             	mov    (%rax),%rax
  80479e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8047a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047a8:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  8047aa:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8047b1:	00 00 00 
  8047b4:	48 8b 00             	mov    (%rax),%rax
  8047b7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  8047bd:	c9                   	leaveq 
  8047be:	c3                   	retq   

00000000008047bf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8047bf:	55                   	push   %rbp
  8047c0:	48 89 e5             	mov    %rsp,%rbp
  8047c3:	48 83 ec 30          	sub    $0x30,%rsp
  8047c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047ca:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8047cd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8047d1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8047d4:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8047db:	eb 59                	jmp    804836 <ipc_send+0x77>
		if(pg) {
  8047dd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047e2:	74 20                	je     804804 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8047e4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8047e7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8047ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8047ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047f1:	89 c7                	mov    %eax,%edi
  8047f3:	48 b8 20 23 80 00 00 	movabs $0x802320,%rax
  8047fa:	00 00 00 
  8047fd:	ff d0                	callq  *%rax
  8047ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804802:	eb 26                	jmp    80482a <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  804804:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804807:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80480a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80480d:	89 d1                	mov    %edx,%ecx
  80480f:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  804816:	00 00 00 
  804819:	89 c7                	mov    %eax,%edi
  80481b:	48 b8 20 23 80 00 00 	movabs $0x802320,%rax
  804822:	00 00 00 
  804825:	ff d0                	callq  *%rax
  804827:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  80482a:	48 b8 0e 21 80 00 00 	movabs $0x80210e,%rax
  804831:	00 00 00 
  804834:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  804836:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80483a:	74 a1                	je     8047dd <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  80483c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804840:	74 2a                	je     80486c <ipc_send+0xad>
		panic("something went wrong with sending the page");
  804842:	48 ba 20 57 80 00 00 	movabs $0x805720,%rdx
  804849:	00 00 00 
  80484c:	be 49 00 00 00       	mov    $0x49,%esi
  804851:	48 bf 4b 57 80 00 00 	movabs $0x80574b,%rdi
  804858:	00 00 00 
  80485b:	b8 00 00 00 00       	mov    $0x0,%eax
  804860:	48 b9 08 0a 80 00 00 	movabs $0x800a08,%rcx
  804867:	00 00 00 
  80486a:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  80486c:	c9                   	leaveq 
  80486d:	c3                   	retq   

000000000080486e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80486e:	55                   	push   %rbp
  80486f:	48 89 e5             	mov    %rsp,%rbp
  804872:	48 83 ec 18          	sub    $0x18,%rsp
  804876:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804879:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804880:	eb 6a                	jmp    8048ec <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  804882:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804889:	00 00 00 
  80488c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80488f:	48 63 d0             	movslq %eax,%rdx
  804892:	48 89 d0             	mov    %rdx,%rax
  804895:	48 c1 e0 02          	shl    $0x2,%rax
  804899:	48 01 d0             	add    %rdx,%rax
  80489c:	48 01 c0             	add    %rax,%rax
  80489f:	48 01 d0             	add    %rdx,%rax
  8048a2:	48 c1 e0 05          	shl    $0x5,%rax
  8048a6:	48 01 c8             	add    %rcx,%rax
  8048a9:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8048af:	8b 00                	mov    (%rax),%eax
  8048b1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048b4:	75 32                	jne    8048e8 <ipc_find_env+0x7a>
			return envs[i].env_id;
  8048b6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048bd:	00 00 00 
  8048c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048c3:	48 63 d0             	movslq %eax,%rdx
  8048c6:	48 89 d0             	mov    %rdx,%rax
  8048c9:	48 c1 e0 02          	shl    $0x2,%rax
  8048cd:	48 01 d0             	add    %rdx,%rax
  8048d0:	48 01 c0             	add    %rax,%rax
  8048d3:	48 01 d0             	add    %rdx,%rax
  8048d6:	48 c1 e0 05          	shl    $0x5,%rax
  8048da:	48 01 c8             	add    %rcx,%rax
  8048dd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8048e3:	8b 40 08             	mov    0x8(%rax),%eax
  8048e6:	eb 12                	jmp    8048fa <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8048e8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8048ec:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8048f3:	7e 8d                	jle    804882 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8048f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048fa:	c9                   	leaveq 
  8048fb:	c3                   	retq   

00000000008048fc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8048fc:	55                   	push   %rbp
  8048fd:	48 89 e5             	mov    %rsp,%rbp
  804900:	48 83 ec 18          	sub    $0x18,%rsp
  804904:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80490c:	48 89 c2             	mov    %rax,%rdx
  80490f:	48 c1 ea 15          	shr    $0x15,%rdx
  804913:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80491a:	01 00 00 
  80491d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804921:	83 e0 01             	and    $0x1,%eax
  804924:	48 85 c0             	test   %rax,%rax
  804927:	75 07                	jne    804930 <pageref+0x34>
		return 0;
  804929:	b8 00 00 00 00       	mov    $0x0,%eax
  80492e:	eb 53                	jmp    804983 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804934:	48 89 c2             	mov    %rax,%rdx
  804937:	48 c1 ea 0c          	shr    $0xc,%rdx
  80493b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804942:	01 00 00 
  804945:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804949:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80494d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804951:	83 e0 01             	and    $0x1,%eax
  804954:	48 85 c0             	test   %rax,%rax
  804957:	75 07                	jne    804960 <pageref+0x64>
		return 0;
  804959:	b8 00 00 00 00       	mov    $0x0,%eax
  80495e:	eb 23                	jmp    804983 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804960:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804964:	48 89 c2             	mov    %rax,%rdx
  804967:	48 c1 ea 0c          	shr    $0xc,%rdx
  80496b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804972:	00 00 00 
  804975:	48 c1 e2 04          	shl    $0x4,%rdx
  804979:	48 01 d0             	add    %rdx,%rax
  80497c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804980:	0f b7 c0             	movzwl %ax,%eax
}
  804983:	c9                   	leaveq 
  804984:	c3                   	retq   
  804985:	00 00                	add    %al,(%rax)
	...

0000000000804988 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804988:	55                   	push   %rbp
  804989:	48 89 e5             	mov    %rsp,%rbp
  80498c:	48 83 ec 20          	sub    $0x20,%rsp
  804990:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804994:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80499c:	48 89 d6             	mov    %rdx,%rsi
  80499f:	48 89 c7             	mov    %rax,%rdi
  8049a2:	48 b8 be 49 80 00 00 	movabs $0x8049be,%rax
  8049a9:	00 00 00 
  8049ac:	ff d0                	callq  *%rax
  8049ae:	85 c0                	test   %eax,%eax
  8049b0:	74 05                	je     8049b7 <inet_addr+0x2f>
    return (val.s_addr);
  8049b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8049b5:	eb 05                	jmp    8049bc <inet_addr+0x34>
  }
  return (INADDR_NONE);
  8049b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8049bc:	c9                   	leaveq 
  8049bd:	c3                   	retq   

00000000008049be <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8049be:	55                   	push   %rbp
  8049bf:	48 89 e5             	mov    %rsp,%rbp
  8049c2:	53                   	push   %rbx
  8049c3:	48 83 ec 48          	sub    $0x48,%rsp
  8049c7:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8049cb:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8049cf:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8049d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  c = *cp;
  8049d7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8049db:	0f b6 00             	movzbl (%rax),%eax
  8049de:	0f be c0             	movsbl %al,%eax
  8049e1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8049e4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049e7:	3c 2f                	cmp    $0x2f,%al
  8049e9:	76 07                	jbe    8049f2 <inet_aton+0x34>
  8049eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049ee:	3c 39                	cmp    $0x39,%al
  8049f0:	76 0a                	jbe    8049fc <inet_aton+0x3e>
      return (0);
  8049f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8049f7:	e9 6a 02 00 00       	jmpq   804c66 <inet_aton+0x2a8>
    val = 0;
  8049fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    base = 10;
  804a03:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%rbp)
    if (c == '0') {
  804a0a:	83 7d e4 30          	cmpl   $0x30,-0x1c(%rbp)
  804a0e:	75 40                	jne    804a50 <inet_aton+0x92>
      c = *++cp;
  804a10:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804a15:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804a19:	0f b6 00             	movzbl (%rax),%eax
  804a1c:	0f be c0             	movsbl %al,%eax
  804a1f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if (c == 'x' || c == 'X') {
  804a22:	83 7d e4 78          	cmpl   $0x78,-0x1c(%rbp)
  804a26:	74 06                	je     804a2e <inet_aton+0x70>
  804a28:	83 7d e4 58          	cmpl   $0x58,-0x1c(%rbp)
  804a2c:	75 1b                	jne    804a49 <inet_aton+0x8b>
        base = 16;
  804a2e:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
        c = *++cp;
  804a35:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804a3a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804a3e:	0f b6 00             	movzbl (%rax),%eax
  804a41:	0f be c0             	movsbl %al,%eax
  804a44:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804a47:	eb 07                	jmp    804a50 <inet_aton+0x92>
      } else
        base = 8;
  804a49:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804a50:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804a53:	3c 2f                	cmp    $0x2f,%al
  804a55:	76 2f                	jbe    804a86 <inet_aton+0xc8>
  804a57:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804a5a:	3c 39                	cmp    $0x39,%al
  804a5c:	77 28                	ja     804a86 <inet_aton+0xc8>
        val = (val * base) + (int)(c - '0');
  804a5e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a61:	89 c2                	mov    %eax,%edx
  804a63:	0f af 55 ec          	imul   -0x14(%rbp),%edx
  804a67:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804a6a:	01 d0                	add    %edx,%eax
  804a6c:	83 e8 30             	sub    $0x30,%eax
  804a6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  804a72:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804a77:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804a7b:	0f b6 00             	movzbl (%rax),%eax
  804a7e:	0f be c0             	movsbl %al,%eax
  804a81:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804a84:	eb ca                	jmp    804a50 <inet_aton+0x92>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804a86:	83 7d e8 10          	cmpl   $0x10,-0x18(%rbp)
  804a8a:	75 74                	jne    804b00 <inet_aton+0x142>
  804a8c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804a8f:	3c 2f                	cmp    $0x2f,%al
  804a91:	76 07                	jbe    804a9a <inet_aton+0xdc>
  804a93:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804a96:	3c 39                	cmp    $0x39,%al
  804a98:	76 1c                	jbe    804ab6 <inet_aton+0xf8>
  804a9a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804a9d:	3c 60                	cmp    $0x60,%al
  804a9f:	76 07                	jbe    804aa8 <inet_aton+0xea>
  804aa1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804aa4:	3c 66                	cmp    $0x66,%al
  804aa6:	76 0e                	jbe    804ab6 <inet_aton+0xf8>
  804aa8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804aab:	3c 40                	cmp    $0x40,%al
  804aad:	76 51                	jbe    804b00 <inet_aton+0x142>
  804aaf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ab2:	3c 46                	cmp    $0x46,%al
  804ab4:	77 4a                	ja     804b00 <inet_aton+0x142>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804ab6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ab9:	89 c2                	mov    %eax,%edx
  804abb:	c1 e2 04             	shl    $0x4,%edx
  804abe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ac1:	8d 48 0a             	lea    0xa(%rax),%ecx
  804ac4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ac7:	3c 60                	cmp    $0x60,%al
  804ac9:	76 0e                	jbe    804ad9 <inet_aton+0x11b>
  804acb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ace:	3c 7a                	cmp    $0x7a,%al
  804ad0:	77 07                	ja     804ad9 <inet_aton+0x11b>
  804ad2:	b8 61 00 00 00       	mov    $0x61,%eax
  804ad7:	eb 05                	jmp    804ade <inet_aton+0x120>
  804ad9:	b8 41 00 00 00       	mov    $0x41,%eax
  804ade:	89 cb                	mov    %ecx,%ebx
  804ae0:	29 c3                	sub    %eax,%ebx
  804ae2:	89 d8                	mov    %ebx,%eax
  804ae4:	09 d0                	or     %edx,%eax
  804ae6:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  804ae9:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804aee:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804af2:	0f b6 00             	movzbl (%rax),%eax
  804af5:	0f be c0             	movsbl %al,%eax
  804af8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else
        break;
    }
  804afb:	e9 50 ff ff ff       	jmpq   804a50 <inet_aton+0x92>
    if (c == '.') {
  804b00:	83 7d e4 2e          	cmpl   $0x2e,-0x1c(%rbp)
  804b04:	75 3d                	jne    804b43 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804b06:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804b0a:	48 83 c0 0c          	add    $0xc,%rax
  804b0e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804b12:	72 0a                	jb     804b1e <inet_aton+0x160>
        return (0);
  804b14:	b8 00 00 00 00       	mov    $0x0,%eax
  804b19:	e9 48 01 00 00       	jmpq   804c66 <inet_aton+0x2a8>
      *pp++ = val;
  804b1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b22:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804b25:	89 10                	mov    %edx,(%rax)
  804b27:	48 83 45 d8 04       	addq   $0x4,-0x28(%rbp)
      c = *++cp;
  804b2c:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804b31:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804b35:	0f b6 00             	movzbl (%rax),%eax
  804b38:	0f be c0             	movsbl %al,%eax
  804b3b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    } else
      break;
  }
  804b3e:	e9 a1 fe ff ff       	jmpq   8049e4 <inet_aton+0x26>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804b43:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804b44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804b48:	74 3c                	je     804b86 <inet_aton+0x1c8>
  804b4a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804b4d:	3c 1f                	cmp    $0x1f,%al
  804b4f:	76 2b                	jbe    804b7c <inet_aton+0x1be>
  804b51:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804b54:	84 c0                	test   %al,%al
  804b56:	78 24                	js     804b7c <inet_aton+0x1be>
  804b58:	83 7d e4 20          	cmpl   $0x20,-0x1c(%rbp)
  804b5c:	74 28                	je     804b86 <inet_aton+0x1c8>
  804b5e:	83 7d e4 0c          	cmpl   $0xc,-0x1c(%rbp)
  804b62:	74 22                	je     804b86 <inet_aton+0x1c8>
  804b64:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  804b68:	74 1c                	je     804b86 <inet_aton+0x1c8>
  804b6a:	83 7d e4 0d          	cmpl   $0xd,-0x1c(%rbp)
  804b6e:	74 16                	je     804b86 <inet_aton+0x1c8>
  804b70:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  804b74:	74 10                	je     804b86 <inet_aton+0x1c8>
  804b76:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%rbp)
  804b7a:	74 0a                	je     804b86 <inet_aton+0x1c8>
    return (0);
  804b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  804b81:	e9 e0 00 00 00       	jmpq   804c66 <inet_aton+0x2a8>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804b86:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804b8a:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804b8e:	48 89 d1             	mov    %rdx,%rcx
  804b91:	48 29 c1             	sub    %rax,%rcx
  804b94:	48 89 c8             	mov    %rcx,%rax
  804b97:	48 c1 f8 02          	sar    $0x2,%rax
  804b9b:	83 c0 01             	add    $0x1,%eax
  804b9e:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  switch (n) {
  804ba1:	83 7d d4 04          	cmpl   $0x4,-0x2c(%rbp)
  804ba5:	0f 87 98 00 00 00    	ja     804c43 <inet_aton+0x285>
  804bab:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804bae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804bb5:	00 
  804bb6:	48 b8 58 57 80 00 00 	movabs $0x805758,%rax
  804bbd:	00 00 00 
  804bc0:	48 01 d0             	add    %rdx,%rax
  804bc3:	48 8b 00             	mov    (%rax),%rax
  804bc6:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  804bcd:	e9 94 00 00 00       	jmpq   804c66 <inet_aton+0x2a8>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804bd2:	81 7d ec ff ff ff 00 	cmpl   $0xffffff,-0x14(%rbp)
  804bd9:	76 0a                	jbe    804be5 <inet_aton+0x227>
      return (0);
  804bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  804be0:	e9 81 00 00 00       	jmpq   804c66 <inet_aton+0x2a8>
    val |= parts[0] << 24;
  804be5:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804be8:	c1 e0 18             	shl    $0x18,%eax
  804beb:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804bee:	eb 53                	jmp    804c43 <inet_aton+0x285>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804bf0:	81 7d ec ff ff 00 00 	cmpl   $0xffff,-0x14(%rbp)
  804bf7:	76 07                	jbe    804c00 <inet_aton+0x242>
      return (0);
  804bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  804bfe:	eb 66                	jmp    804c66 <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804c00:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804c03:	89 c2                	mov    %eax,%edx
  804c05:	c1 e2 18             	shl    $0x18,%edx
  804c08:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804c0b:	c1 e0 10             	shl    $0x10,%eax
  804c0e:	09 d0                	or     %edx,%eax
  804c10:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804c13:	eb 2e                	jmp    804c43 <inet_aton+0x285>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804c15:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%rbp)
  804c1c:	76 07                	jbe    804c25 <inet_aton+0x267>
      return (0);
  804c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  804c23:	eb 41                	jmp    804c66 <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804c25:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804c28:	89 c2                	mov    %eax,%edx
  804c2a:	c1 e2 18             	shl    $0x18,%edx
  804c2d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804c30:	c1 e0 10             	shl    $0x10,%eax
  804c33:	09 c2                	or     %eax,%edx
  804c35:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804c38:	c1 e0 08             	shl    $0x8,%eax
  804c3b:	09 d0                	or     %edx,%eax
  804c3d:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804c40:	eb 01                	jmp    804c43 <inet_aton+0x285>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  804c42:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804c43:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  804c48:	74 17                	je     804c61 <inet_aton+0x2a3>
    addr->s_addr = htonl(val);
  804c4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804c4d:	89 c7                	mov    %eax,%edi
  804c4f:	48 b8 d5 4d 80 00 00 	movabs $0x804dd5,%rax
  804c56:	00 00 00 
  804c59:	ff d0                	callq  *%rax
  804c5b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  804c5f:	89 02                	mov    %eax,(%rdx)
  return (1);
  804c61:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804c66:	48 83 c4 48          	add    $0x48,%rsp
  804c6a:	5b                   	pop    %rbx
  804c6b:	5d                   	pop    %rbp
  804c6c:	c3                   	retq   

0000000000804c6d <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804c6d:	55                   	push   %rbp
  804c6e:	48 89 e5             	mov    %rsp,%rbp
  804c71:	48 83 ec 30          	sub    $0x30,%rsp
  804c75:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804c78:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804c7b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804c7e:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804c85:	00 00 00 
  804c88:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804c8c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804c90:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804c94:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804c98:	e9 d1 00 00 00       	jmpq   804d6e <inet_ntoa+0x101>
    i = 0;
  804c9d:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  804ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ca5:	0f b6 08             	movzbl (%rax),%ecx
  804ca8:	0f b6 d1             	movzbl %cl,%edx
  804cab:	89 d0                	mov    %edx,%eax
  804cad:	c1 e0 02             	shl    $0x2,%eax
  804cb0:	01 d0                	add    %edx,%eax
  804cb2:	c1 e0 03             	shl    $0x3,%eax
  804cb5:	01 d0                	add    %edx,%eax
  804cb7:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804cbe:	01 d0                	add    %edx,%eax
  804cc0:	66 c1 e8 08          	shr    $0x8,%ax
  804cc4:	c0 e8 03             	shr    $0x3,%al
  804cc7:	88 45 ed             	mov    %al,-0x13(%rbp)
  804cca:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804cce:	89 d0                	mov    %edx,%eax
  804cd0:	c1 e0 02             	shl    $0x2,%eax
  804cd3:	01 d0                	add    %edx,%eax
  804cd5:	01 c0                	add    %eax,%eax
  804cd7:	89 ca                	mov    %ecx,%edx
  804cd9:	28 c2                	sub    %al,%dl
  804cdb:	89 d0                	mov    %edx,%eax
  804cdd:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  804ce0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ce4:	0f b6 00             	movzbl (%rax),%eax
  804ce7:	0f b6 d0             	movzbl %al,%edx
  804cea:	89 d0                	mov    %edx,%eax
  804cec:	c1 e0 02             	shl    $0x2,%eax
  804cef:	01 d0                	add    %edx,%eax
  804cf1:	c1 e0 03             	shl    $0x3,%eax
  804cf4:	01 d0                	add    %edx,%eax
  804cf6:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804cfd:	01 d0                	add    %edx,%eax
  804cff:	66 c1 e8 08          	shr    $0x8,%ax
  804d03:	89 c2                	mov    %eax,%edx
  804d05:	c0 ea 03             	shr    $0x3,%dl
  804d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d0c:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804d0e:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804d12:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804d16:	83 c2 30             	add    $0x30,%edx
  804d19:	48 98                	cltq   
  804d1b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  804d1f:	80 45 ee 01          	addb   $0x1,-0x12(%rbp)
    } while(*ap);
  804d23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d27:	0f b6 00             	movzbl (%rax),%eax
  804d2a:	84 c0                	test   %al,%al
  804d2c:	0f 85 6f ff ff ff    	jne    804ca1 <inet_ntoa+0x34>
    while(i--)
  804d32:	eb 16                	jmp    804d4a <inet_ntoa+0xdd>
      *rp++ = inv[i];
  804d34:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804d38:	48 98                	cltq   
  804d3a:	0f b6 54 05 e0       	movzbl -0x20(%rbp,%rax,1),%edx
  804d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d43:	88 10                	mov    %dl,(%rax)
  804d45:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  804d4a:	80 7d ee 00          	cmpb   $0x0,-0x12(%rbp)
  804d4e:	0f 95 c0             	setne  %al
  804d51:	80 6d ee 01          	subb   $0x1,-0x12(%rbp)
  804d55:	84 c0                	test   %al,%al
  804d57:	75 db                	jne    804d34 <inet_ntoa+0xc7>
      *rp++ = inv[i];
    *rp++ = '.';
  804d59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d5d:	c6 00 2e             	movb   $0x2e,(%rax)
  804d60:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    ap++;
  804d65:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  804d6a:	80 45 ef 01          	addb   $0x1,-0x11(%rbp)
  804d6e:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  804d72:	0f 86 25 ff ff ff    	jbe    804c9d <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804d78:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d81:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804d84:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804d8b:	00 00 00 
}
  804d8e:	c9                   	leaveq 
  804d8f:	c3                   	retq   

0000000000804d90 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804d90:	55                   	push   %rbp
  804d91:	48 89 e5             	mov    %rsp,%rbp
  804d94:	48 83 ec 08          	sub    $0x8,%rsp
  804d98:	89 f8                	mov    %edi,%eax
  804d9a:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804d9e:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804da2:	c1 e0 08             	shl    $0x8,%eax
  804da5:	89 c2                	mov    %eax,%edx
  804da7:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804dab:	66 c1 e8 08          	shr    $0x8,%ax
  804daf:	09 d0                	or     %edx,%eax
}
  804db1:	c9                   	leaveq 
  804db2:	c3                   	retq   

0000000000804db3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804db3:	55                   	push   %rbp
  804db4:	48 89 e5             	mov    %rsp,%rbp
  804db7:	48 83 ec 08          	sub    $0x8,%rsp
  804dbb:	89 f8                	mov    %edi,%eax
  804dbd:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  804dc1:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804dc5:	89 c7                	mov    %eax,%edi
  804dc7:	48 b8 90 4d 80 00 00 	movabs $0x804d90,%rax
  804dce:	00 00 00 
  804dd1:	ff d0                	callq  *%rax
}
  804dd3:	c9                   	leaveq 
  804dd4:	c3                   	retq   

0000000000804dd5 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  804dd5:	55                   	push   %rbp
  804dd6:	48 89 e5             	mov    %rsp,%rbp
  804dd9:	48 83 ec 08          	sub    $0x8,%rsp
  804ddd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  804de0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804de3:	89 c2                	mov    %eax,%edx
  804de5:	c1 e2 18             	shl    $0x18,%edx
    ((n & 0xff00) << 8) |
  804de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804deb:	25 00 ff 00 00       	and    $0xff00,%eax
  804df0:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804df3:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  804df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804df8:	25 00 00 ff 00       	and    $0xff0000,%eax
  804dfd:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804e01:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  804e03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e06:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804e09:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  804e0b:	c9                   	leaveq 
  804e0c:	c3                   	retq   

0000000000804e0d <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804e0d:	55                   	push   %rbp
  804e0e:	48 89 e5             	mov    %rsp,%rbp
  804e11:	48 83 ec 08          	sub    $0x8,%rsp
  804e15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e1b:	89 c7                	mov    %eax,%edi
  804e1d:	48 b8 d5 4d 80 00 00 	movabs $0x804dd5,%rax
  804e24:	00 00 00 
  804e27:	ff d0                	callq  *%rax
}
  804e29:	c9                   	leaveq 
  804e2a:	c3                   	retq   
