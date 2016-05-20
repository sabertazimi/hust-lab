C /* $Revision: 1.1 $ */
C This is for nt only!!
C
C These are the interfaces needed to accomodate
C the use of %VAL when these functions are called.
C An Interface block needs to be added for any
C new subroutine which uses %VAL.
C		    
      INTERFACE 
      SUBROUTINE REMEZF ( NFILT, NEG, NBANDS, NGRID, 
     1     EP, GRIDP, DESP, WTP, 
     2     AD, X, Y, ALPHA, 
     3     A, P, Q, 
     4     HP, ERR, IEXT ) 
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER NFILT, NEG, NBANDS, NGRID
      REAL*8 EP, GRIDP, DESP, WTP
      REAL*8 AD, X, Y, ALPHA
      REAL*8 A, P, Q, HP, ERR, IEXT
      END SUBROUTINE REMEZF
      END INTERFACE
C
      INTERFACE 
      SUBROUTINE MXCOPYPTRTOREAL8(A, B, C)
      REAL*8 B
      INTEGER*4 A, C
      END SUBROUTINE MXCOPYPTRTOREAL8
      END INTERFACE
C
      INTERFACE 
      SUBROUTINE MXCOPYREAL8TOPTR(A, B, C)
      REAL*8 A
      INTEGER*4 B, C
      END SUBROUTINE MXCOPYREAL8TOPTR
      END INTERFACE

