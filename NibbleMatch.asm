include \masm32\include\masm32rt.inc

; DWORD params are read backwards on this architecture
.data
    userInput DWORD ?
    
    ; A is 0100 0001
    fA DWORD "1000"
    lA DWORD "0010"
    
    ; K is 0100 1011
    fK DWORD "1101"
    lK DWORD "0010"
    count SDWORD 0

.code
    quit PROC string: PTR BYTE
        mov eax, len(string)
        cmp eax, 4
        jne false ; str is not 4 chars
        mov eax, string
        cmp BYTE PTR[eax], 'q'
        jne false ; if char1 != q, return false
        inc eax
        cmp BYTE PTR[eax], 'u'
        jne false ; if char2 != u, return false
        inc eax
        cmp BYTE PTR[eax], 'i'
        jne false ; if char3 != i, return false
        inc eax
        cmp BYTE PTR[eax], 't'
        jne false ; if char4 != t, return false
        mov eax, 1
        ret

        false:
            mov eax, 0
            ret
    quit ENDP

    isValid PROC uses EBX string: PTR BYTE
        mov eax, len(string) ; EAX <- iteration counter
        cmp eax, 4
        jne false ; if str length != 4, return false
        mov ebx, string ; EBX <- location of 1st char at str
        dec ebx ; prepare for loop
        jmp iterate

        iterate:
            cmp eax, 0
            je true ; if all iterations done, return true
            inc ebx ; next char location in str
            cmp BYTE PTR[ebx], '0'
            jne check1 ; if char != 0, check if char == 1
            dec eax ; next iteration
            jmp iterate

        check1:
            cmp BYTE PTR[ebx], '1'
            jne false ; if char != 1 && char != 0, return false
            dec eax ; next iteration
            jmp iterate

        true:
            mov eax, 1
            ret

        false:
            mov eax, 0
            ret
    isValid ENDP

    compare PROC uses EBX ECX str1: PTR BYTE, str2: PTR BYTE
        mov eax, 0 ; EAX <- iteration counter
        mov ebx, str1 ; EBX <- location of 1st char at str1
        jmp iterate

        iterate:
            cmp eax, 4
            je true ; if all iterations done, return true
            mov cl, BYTE PTR[ebx]
            cmp cl, BYTE PTR[str2+eax]
            jne false ; if char at str1 != char at str2, return false
            inc eax ; next iteration
            inc ebx ; next char location in str1
            jmp iterate

        true:
            mov eax, 1
            ret

        false:
            mov eax, 0
            ret
    compare ENDP
    
    countMatches PROC string: DWORD
        mov count, 0
        invoke compare, string, fA
        add count, eax
        invoke compare, string, lA
        add count, eax
        invoke compare, string, fK
        add count, eax
        invoke compare, string, lK
        add count, eax
        mov eax, count
        ret
    countMatches ENDP

    start:
        mov userInput, input("Enter a string of 4 bits (type ""quit"" to exit): ")
        invoke quit, userInput
        cmp eax,1 ; userInput == "quit"
        je terminate
        invoke isValid,userInput
        cmp eax,1 ; userInput is valid
        jne start
        invoke countMatches, userInput
        ccout "Your input matches with "
        ccout sstr$(count)
        ccout " nibble(s)\n"
        jmp start
        
        terminate:
            exit
     end start