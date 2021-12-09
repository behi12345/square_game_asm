.model small
.stack 8       ;a 8 byte stack
.data

      message0 db 30, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196,196, 196, 196, 31, "$"  ;for printing _ characters
      message1 db 10, 'Simple Game', "$"                                                                                          
      message2 db 10, '1.Start', "$"     
      message3 db 10, '2.Exit', "$" 
      message4 db 10, 'Please choose a number:', "$"      
      message5 db 10, 7, 'Move: a, w, s, d', "$" 
      message6 db 10, 'Cross the green line: Winner', "$"
      message7 db 10, 'Cross the red line: Loser', "$" 
      message8 db 10, 'Please wait while loading... ', "$" 
      message9 db 10, 'You won!',7 ,7, "$"
      message10 db 10, 'You lost!',7 ,7, "$"
      squarePosX dw ?            ;stores first X position of square
      squarePosY dw ?            ;stores first Y position of square
      linePosX dw ?              ;stores first X position of line
      linePosY dw ?              ;stores first Y position of line     
      
.code 

    Main proc far      
            
      push 0
      SQURE_SIZE equ 4  
      mov ax, @data             ;stores address of data segment in ax segment
      mov ds, ax                ;stores ax segment in data segment register
      mov dl, 32                ;position of curser column
      mov dh, 3                 ;position of curser row
      call SetCursorPosition
      lea  dx, message0
      call PrintStrings         ;prints strings
      mov dl, 35
      mov dh, 4
      call SetCursorPosition
      lea  dx, message1
      call PrintStrings
      mov dl, 32
      mov dh, 7
      call SetCursorPosition
      lea  dx, message0
      call PrintStrings
      mov dl, 37
      mov dh, 10
      call SetCursorPosition
      lea  dx, message2
      call PrintStrings
      mov dl, 37
      mov dh, 12
      call SetCursorPosition
      lea  dx, message3
      call PrintStrings
      mov dl, 30
      mov dh, 15
      call SetCursorPosition
      lea  dx, message4
      call PrintStrings      
      call GetAnswer
      mov dl, 1
      mov dh, 1
      call SetCursorPosition
      lea  dx, message5
      call PrintStrings       
      mov dl, 1
      mov dh, 5
      call SetCursorPosition
      lea  dx, message6
      call PrintStrings
      mov dl, 1
      mov dh, 9
      call SetCursorPosition
      lea  dx, message7
      call PrintStrings      
      mov dl, 1
      mov dh, 13 
      call SetCursorPosition
      lea  dx, message8
      call PrintStrings     
      mov al, 0xc            ;sets Color of pixels
      mov cx, 200            ;position of pixel on X axis
      mov dx, 200            ;position of pixel on Y axis         
      call DrawALine 
      mov al, 0xa
      mov cx, 420
      mov dx, 200
      call DrawALine
      mov al, 0xb
      mov cx, 310
      mov dx, 200    
      
      back:
      
      mov al, 0x0b
      call DrawASquare
      call CheckSquareStatus      
      
      askInputAgain:
      
      mov ah, 0x0
      int 0x16               ;gets a character from user
      cmp ah, 0x20           ;if that character was 'd'
      jz moveRight           ;jumps on 'moveRight' label
      cmp ah, 0x11           ;if that character was 'w'
      jz moveUp              ;jumps on 'moveUp' label
      cmp ah, 0x1e           ;if that character was 'a'
      jz moveLeft            ;jumps on 'moveLeft' label
      cmp ah, 0x1f           ;if that character was 's'
      jz moveDown            ;jumps on 'moveDown' label
      jmp askInputAgain      ;if none above jumps 'askInputAgain' label
      
      moveRight:
      
     ; mov al, 0x00          ;if you want to square to be cleaned from last location uncomment this section 
     ; call DrawASquare      ;if you want to square to be cleaned from last location uncomment this section 
      add cx, 15             ;moves square 15 pixels to the right  
      jmp back
      
      moveUp:
      
     ; mov al, 0x00          ;if you want to square to be cleaned from last location uncomment this section 
     ; call DrawASquare      ;if you want to square to be cleaned from last location uncomment this section 
      sub dx, 15             ;moves square 15 pixels to the up  
      jmp back
      
      moveLeft:
      
     ; mov al, 0x00          ;if you want to square to be cleaned from last location uncomment this section 
     ; call DrawASquare      ;if you want to square to be cleaned from last location uncomment this section 
      sub cx, 15             ;moves square 15 pixels to the left     
      jmp back
      
      moveDown:       
      
     ; mov al, 0x00          ;if you want to square to be cleaned from last location uncomment this section 
     ; call DrawASquare      ;if you want to square to be cleaned from last location uncomment this section          
      add dx, 15             ;moves square 15 pixels to the down 
      jmp back         
               
      ret 0
     
    Main endp
    
;This function moves cursor 

    SetCursorPosition proc near
     
      mov ah, 0x2
      mov bh, 0
      int 0x10
      ret
       
    SetCursorPosition endp
    
;This function prints strings

    PrintStrings proc near
        
      mov ah, 0x9
      int 0x21
      ret 
        
    PrintStrings endp
    
;This function gets answer from user and changes video mode

    GetAnswer proc near
        
      askAgain:
       
      mov ah, 0x0
      int 0x16
      cmp ah, 0x3
      jz answer2
      cmp ah, 0x2
      jz answer1      
      jmp askAgain
              
      answer1:
       
        mov ah, 0x0
        mov al, 0x12
        int 0x10
        ret               
                          
      answer2:
       
        mov ah, 0x00
        int 0x21                   
        
   GetAnswer endp    

;This function draws the square
 
   DrawASquare proc near
    
      lea bx, squarePosX
      mov [bx], cx
      lea bx, squarePosY
      mov [bx], dx      
      mov ah, 0x0c 
      mov di, 0
       
      for0:
       
      add di, 2
      cmp di, SQURE_SIZE    
      jnbe endFor0
                
         mov si, 0
          
         for1:
          
         cmp si, SQURE_SIZE
         jz endFor1
                        
            int 0x10
            inc cx
            inc si
            jmp for1
                              
         endFor1:
         inc dx
         mov si, 0 
                    
         for2:
                     
         cmp si, SQURE_SIZE
         jz endFor2
          
            dec cx
            inc si
            int 0x10
            jmp for2
             
         endFor2: 
          
         inc dx            
         jmp for0        
          
      endFor0:     
            
      mov cx, squarePosX
      mov dx, squarePosY          
      ret
                
    
  DrawASquare endp   
   
;This function draws the line

  DrawALine proc near
    
      lea bx, linePosX
      mov [bx], cx
      lea bx, linePosY
      mov [bx], dx
      mov ah, 0x0c
      mov di, 0
       
      for3:
       
      cmp di, 2
      jz endFor3
                
         mov si, 0
          
         for4:
          
         cmp si, 40
         jz endFor4
                        
            int 0x10
            inc dx
            inc si
            jmp for4
             
         endFor4:
          
         inc di
         inc cx
         mov si, 0 
                    
         for5:
                     
         cmp si, 40
         jz endFor5
          
            dec dx
            inc si
            int 0x10
            jmp for5
             
         endFor5:   
          
         inc di            
         jmp for3
          
      endFor3:     
      
      ret
    
  DrawALine endp
   
;This functon checks status of the square

  CheckSquareStatus proc near
         
      cmp cx, 420            ;if X location of the square was over 420...
      jnbe winner            ;jumps 'winner' label
      cmp cx, 200            ;...
      jna loser              ;...
      ret
        
        winner:              ;if user was winner opens new window and prints message9
        
        mov ah, 0x0
        mov al, 0x12
        int 0x10
        mov dl, 35
        mov dh, 25
        call SetCursorPosition
        lea dx, message9 
        call PrintStrings
        ret
        
        loser:               ;if user was winner opens new window and prints message10
        
        mov ah, 0x0
        mov al, 0x12
        int 0x10
        mov dl, 36
        mov dh, 25
        call SetCursorPosition
        lea dx, message10 
        call PrintStrings
        ret
          
  CheckSquareStatus endp
            
end Main        