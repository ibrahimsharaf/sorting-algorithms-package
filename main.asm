
INCLUDE Irvine32.inc
.data
str1 byte  'Please enter the numpers you want to sort: ',0
str2 byte 'The array after sorting :',0
str3 byte 'The array after sorting (using   Quick   sort) :',0
str4 byte 'The array after sorting (using Selection sort) :',0
str5 byte 'The array after sorting (using Insertion sort) :',0
str6 byte 'The array befor sorting :',0

str7 byte 'Time Used By Quick sort :' ,0
str8 byte 'Time Used By selection sort :',0
str9 byte 'Time Used By insertion sort :',0
ms byte ' millisecond',0

space byte  ' ',0
array byte 100 dup(?)
qarray byte 100 dup(?)
iarray byte 100 dup(?)
sarray byte 100 dup(?)
exsize dword ?
exsize1 dword ?
iquick dword ?
jquick dword ?
tmpquick dword ?
pivotquick dword ?
gg dword 2

pivot_index dword ?
pivot_value dword ?
tmpval1 dword ?
tmpval2 dword ?


quick_time dword ?
insertion_time dword ?
selection_time dword ?

.code
main PROC
	mov ecx,100
	mov esi,offset array
	call read_from_user

	;--------------------------insertion call---------------------------
	mov ebx,0
	rdtsc
	mov ebx,eax
	push ebx
	mov esi,offset iarray
	mov ecx,exsize
	call insertion_sort
	rdtsc
	pop ebx
	sub eax,ebx
	mov insertion_time,eax

	;--------------------------selection call---------------------------
	mov ebx,0
	rdtsc
	mov ebx,eax
	push ebx
	mov esi,offset sarray
	mov ecx,exsize
	call selection_sort
	rdtsc
	pop ebx
	sub eax,ebx
	mov selection_time,eax

	;--------------------------quick call-------------------------------

	pushad
	rdtsc
	mov quick_time,eax
	popad

	mov eax,0
	mov ebx,0
	mov edx,0
	mov ecx,exsize
	dec ecx
	mov dl,cl;right
	mov dh,0;left
	
	

	mov esi ,offset qarray
	call quick_sort
	
	
	rdtsc
	sub eax,quick_time
	mov quick_time,eax

	;----------------------unsorted array display-----------------------
	mov esi,offset array
	mov ecx,exsize
	mov edx,offset str6
	call writestring
	call display_to_user
	call crlf

	
	;------------------------selection display--------------------------
	mov esi,offset sarray
	mov ecx,exsize
	mov edx,offset  str4
	call writestring
	call display_to_user
	mov edx,offset str8
	call writestring 
	mov eax,selection_time
	call writedec
	mov edx,offset ms
	call writestring
	call crlf
	call crlf
   
   ;------------------------insertion display--------------------------
   mov esi,offset iarray
	mov ecx,exsize
	mov edx,offset str5
	call writestring
	call display_to_user
	mov edx,offset str9
	call writestring 
	mov eax,insertion_time
	call writedec
	mov edx,offset ms
	call writestring
	call crlf
	call crlf
	;--------------------------quick display----------------------------
	mov esi,offset qarray
	mov ecx,exsize
	mov edx,offset str3
	call writestring
	call display_to_user
	mov edx,offset str7
	call writestring 
	mov eax,quick_time
	call writedec
	mov edx,offset ms
	call writestring
	call crlf
	call crlf

   exit
main ENDP
;--------------------   *read*  ---------------------------------
;Calculates: Read positive numbers from user until -1 is enterd
;Receives: ECX contains the max size of the array
;          ESI contains the offset of array
;Returns: EBX contains exact size of the array
;		  array of positive numbers from user
;----------------------------------------------------------------
 read_from_user PROC
	mov edx,offset str1
	call writestring
	call crlf
	mov ebx,0
 l1:
	call readint 
	cmp eax,-1
	je done
	mov [esi],eax
	inc esi
	inc ebx
 loop l1
 done:
 mov exsize,ebx
 mov ecx,exsize
 mov esi,offset array
 mov esi,offset array
 mov edi,offset qarray
 mov ebx,offset iarray
 mov edx,offset sarray
 l_copy:
	mov eax,[esi]
	mov [edi],eax
	mov [ebx],eax
	mov [edx],eax
	inc esi
	inc edi
	inc ebx
	inc edx
 loop l_copy
 RET
 read_from_user ENDP

 ;-------------------------- *display* ----------------------------------------
 ;Calculates: display array (sorted) to user
 ;Receives: ECX contains exact size of the array
 ;          ESI contains the offset of array
 ;Returns: 
 ;------------------------------------------------------------------------------

 display_to_user PROC
	cmp exsize,0
	je done2
	mov edx,offset space
 l2:
	mov eax,0
	mov al,byte ptr [esi]
	inc esi
	call writedec
	call writestring
 loop l2
 done2:
 call crlf
 RET
 display_to_user ENDP

 ;------------------------- *insertion* ----------------------------------
 ;Calculates:sort posititive array using insertion sort algorithm.
 ;Receives:ESI contains offset of iarray(un sorted).
 ;		   ECX contains exact size of the array.
 ;Returns: iarray(sorted).
 ;-------------------------------------------------------------------------
 insertion_sort PROC
  

 inc esi
 dec ecx
 mov gg,0
  li:
    inc gg
    pushad
	mov ecx,gg
	nli:
	mov al,byte ptr[esi]
	cmp al,[esi-1]
	jae ot
	xchg al,[esi-1]
	mov [esi],al
	ot:
	dec esi
	loop nli
	popad
	inc esi
  loop li
 RET
 insertion_sort ENDP

 ;------------------------- *selection* ----------------------------------
 ;Calculates:sort posititive array using selection sort algorithm
 ;Receives:EBX contains offset of sarray(un sorted)
 ;		   ECX contains exact size of the array
 ;Returns: sarray(sorted)
 ;-------------------------------------------------------------------------
 selection_sort PROC
	dec ecx
    mov exsize1,ecx
	mov esi,0
    mov edx,1

	ls:
		push ecx
		mov ebx,offset sarray
		mov edi,edx
		mov ecx,exsize1
		
		mov al,byte ptr[ebx+esi]
		nls:
			mov ah,byte ptr[ebx+edi]
			cmp al,ah
			jb oot
			mov byte ptr[ebx+esi],ah
			mov byte ptr[ebx+edi],al
			mov al,byte ptr[ebx+esi]
			oot:
				inc edi

		loop nls
			pop ecx
			dec exsize1
			inc esi
			inc edx
	loop ls
	
	
 RET
 selection_sort ENDP

 ;--------------------------- *quick* ------------------------------------
 ;Calculates:sort posititive array using selection sort algorithm
 ;Receives:ESI contains offset of array(un sorted)
 ;		   DL contains Right index
 ;		   DH contains left index
 ;Returns: ESI contains offset of array(sorted)
 ;-------------------------------------------------------------------------
 quick_sort PROC
	mov esi,offset qarray
	mov al,dl         ;al=j=right
	mov ah,dh         ;ah=i=left
	
	push ebx
	push eax

	movzx ebx,dh         ;ebx=left
	movzx eax,dl         ;eax=riht
	add eax,ebx          ;eax=left+right
	shr eax,1            ;eax=eax/2
	
	mov pivot_index,eax  ;pivot=(left+right)/2

	pop eax
	pop ebx

	mov edi,pivot_index  ;edi contains pivot index
	movzx edi,byte ptr [esi+edi] ;edi contains pivot value

	mov pivot_value,edi
	lout:
		lin:
		movzx edi,ah                     ;edi=index of qarray[i]=i
		movzx edi,byte ptr [esi+edi]     ;edi=value of qarray[i]
		
		cmp edi,pivot_value              ;while(qarray[i]<pivot)                       
		jae h
		inc ah                           ;i++
		jmp lin
		h:
		linn:

		movzx edi,al                       ;edi=index of qarray[j]=j
		movzx edi,byte ptr [esi+edi]       ;edi=value of qarray[j]

		cmp edi,pivot_value                ;while(qarray[j]>pivot)
		jbe g
		dec al                             ;j--
		jmp linn
		g: 
		cmp ah,al                          ;if(i<=j)
		ja go_on
		
		 ;-----------------------swap qarray[i],qarray[j]------------------
		movzx edi,ah                       ;edi=index of qarray[i]=i      |
		movzx edi,byte ptr [esi+edi]       ;edi=value of qarray[i]        |
		mov tmpval1,edi                    ;tmpval1=qarray[i]             |
		movzx edi,al                       ;edi=index of qarray[j]=j      |
		movzx edi, byte ptr [esi+edi]      ;edi=value of qarray[j]        |
		mov tmpval2,edi                    ;tmpval2=qarray[j]             |
		movzx edi,ah                       ;edi=index of qarray[i]=i      |
		push ebx                           ;                              |
		mov ebx,tmpval2                    ;                              |
		mov byte ptr [esi+edi],bl          ;                              |
		movzx edi,al                       ;edi=index of qarray[j]=j      |
		mov ebx,tmpval1                    ;                              |
		mov  byte ptr [esi+edi],bl         ;                              |
		pop ebx                            ;                              |
		;-----------------------------------------------------------------

		inc ah                             ;i++
		dec al                             ;j--
		cmp al,-1
		jne jjj
		inc al
		jjj:
		cmp ah,byte ptr exsize
		jne ddd
		ddd:
	go_on:
	cmp ah,al                 
	jbe lout
	cmp dh,al                            ;if(left<j)
	jnb bara
	pushad                               ;save old values of left&right
	mov dl,al                            ;right=j
	call quick_sort                      ;quicksort(arr,left,j)
	popad

	bara:
	cmp ah,dl                            ;if(i<right)
	jnb baraa
	pushad
	mov dh,ah                            ;left=i
	call quick_sort
	popad
	baraa:
 RET
 quick_sort ENDP

END main


//insertion sort c++
 for (int i = 1; i < length; i++)
{
	j = i;
	while (int j > 0 && arr[j - 1] > arr[j])
	{
		tmp = arr[j];
		arr[j] = arr[j - 1];
		arr[j - 1] = tmp;
		j--;
	}
}
--------------------------------------------------
 //selsection sort c++
for (int r1 = 0; r1<n-1; r1++)
	{
		mini = r1;
		for (int r2 = r1 + 1; r2<n; r2++)
		if (arr[r2]<arr[mini])

			mini = r2;

		if (mini != r1)
		{
			temp = arr[r1];
			arr[r1] = arr[mini];
			arr[mini] = temp;
		}
	}

-----------------------------------------------------
	//quick sort c++ divide and conquer algorithm c++
	void quicksort (int arr[],int left,int right)
	{
		int i=left,j=right;
		int tmp;
		int pivot=arr[(left+right)/2];
		while(i<=j)
		{
			while(arr[i]<pivot)
				i++;
			while(arr[j]>pivot)
				j--;
			if(i<=j)
			{
				tmp=arr[i];
				arr[i]=arr[j];
				arr[j]=tmp;
				i++;
				j--;
			}
		}
		if(left<j)
			quicksort(arr,left,j);

		if(i<right)
			quicksort(arr,i,right);

	}


