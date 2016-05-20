
















C REMEZFG.FOR FRONT-END FOR REMEZ FILTER DESIGN PROGRAM
C
C This is an example of the FORTRAN code required for interfacing
C a .MEX file to MATLAB.
C
C The calling syntax from an M file is:
C
C    [h,err,iext] = remezf(nfilt, edge, grid, des, wt, neg)
C
C
C Marc Ullman  June 22, 1987
C Loren Shure  Oct. 5, 1987 revised
C Tom Krauss   July 19, 1993 revised: unlimited filter length and bands
C Copyright (c) 1988-98 by The MathWorks, Inc.
C  $Revision: 1.1 $ 
C
C This subroutine is the main gateway to MATLAB.  When a MEX function
C  is executed MATLAB calls the USRFCN subroutine in the corresponding
C  MEX file.
C
C DO NOT modify this subroutine declaration.
      SUBROUTINE MEXFUNCTION(NLHS, PLHS, NRHS, PRHS)

      INTEGER NLHS, NRHS
C-----------------------------------------------------------------------
C     (integer) Replace integer by integer*8 on the DEC Alpha and the
C     SGI 64-bit platforms
C
      INTEGER PLHS(*), PRHS(*)
      INTEGER   MXCREATEFULL, MXGETPR, MXCALLOC
C-----------------------------------------------------------------------
C

      INTEGER   MXGETM, MXGETN
      REAL*8	MXGETSCALAR

C
C User should modify the following code to fit his requirements.

      INTEGER NFILT, NEG, NBANDS, NGRID, NFCNS
C-----------------------------------------------------------------------
C     (integer) Replace integer by integer*8 on the DEC Alpha and the
C     SGI 64-bit platforms
C
      INTEGER EDGE

C-----------------------------------------------------------------------
C

      INTEGER M,N,MM,NN
      INTEGER GRDSZ

C Pointers to working matrices:
C-----------------------------------------------------------------------
C     (integer) Replace integer by integer*8 on the DEC Alpha and the
C     SGI 64-bit platforms
C
      INTEGER AD, X, Y, IEXT, ALPHA
      INTEGER A, P, Q
      INTEGER GRID, DES, WT
      INTEGER EP, GRIDP, DESP, WTP, HP
      INTEGER ERR
C-----------------------------------------------------------------------
C

C   

C
      IF (NRHS .NE. 6) THEN
        CALL MEXERRMSGTXT('REMEZF requires six input arguments.')
      ELSEIF (NLHS .NE. 3) THEN
        CALL MEXERRMSGTXT('REMEZF requires three output arguments.')
      ENDIF

      NFILT = INT(MXGETSCALAR(PRHS(1)))

      NEG = INT(MXGETSCALAR(PRHS(6)))

      M = MXGETM(PRHS(2))
      N = MXGETN(PRHS(2))
      NBANDS = MAX(M,N)/2
      IF (MIN(M,N) .NE. 1) THEN
        CALL MEXERRMSGTXT('REMEZF requires vector inputs')
      ENDIF

      MM = MXGETM(PRHS(3))
      NN = MXGETN(PRHS(3))
      IF (MIN(MM,NN) .NE. 1) THEN
        CALL MEXERRMSGTXT('REMEZF requires vector inputs')
      ENDIF

      NGRID = MAX(MM,NN)

      MM = MXGETM(PRHS(4))
      NN = MXGETN(PRHS(4))
      IF (MIN(MM,NN) .NE. 1) THEN
        CALL MEXERRMSGTXT('REMEZF requires vector inputs')
      ENDIF

      MM = MXGETM(PRHS(5))
      NN = MXGETN(PRHS(5))
      IF (MIN(MM,NN) .NE. 1) THEN
        CALL MEXERRMSGTXT('REMEZF requires vector inputs')
      ENDIF

C	PUT RHS INTO POINTERS

      EDGE = MXGETPR(PRHS(2))
      GRID = MXGETPR(PRHS(3))
      DES  = MXGETPR(PRHS(4))
      WT   = MXGETPR(PRHS(5))

C       INITIALIZE HEAP MEMORY FOR WORK ARRAYS

      EP = MXCALLOC(NBANDS*2,8)
      GRIDP = MXCALLOC(NGRID*2,8)
      DESP = MXCALLOC(NGRID*2,8)
      WTP = MXCALLOC(NGRID*2,8)

      AD = MXCALLOC(((NFILT+1)/2+3),8)
      X = MXCALLOC(((NFILT+1)/2+3),8)
      Y = MXCALLOC(((NFILT+1)/2+3),8)
      ALPHA = MXCALLOC(((NFILT+1)/2+3),8)
      A = MXCALLOC(((NFILT+1)/2+3),8)
      P = MXCALLOC(((NFILT+1)/2+3),8)
      Q = MXCALLOC(((NFILT+1)/2+3),8)

      GRDSZ = (2*NBANDS)+LGRID*(NFILT/2+3)
      HP = MXCALLOC(((NFILT+1)/2+3),8)
      ERR = MXCALLOC(1,8)
      IEXT = MXCALLOC(((NFILT+1)/2+3),8)

C	PUT POINTERS INTO FORTRAN ARRAYS

      CALL MXCOPYPTRTOREAL8(EDGE,%VAL(EP),M*N)
      CALL MXCOPYPTRTOREAL8(GRID,%VAL(GRIDP),MM*NN)
      CALL MXCOPYPTRTOREAL8(DES,%VAL(DESP),MM*NN)
      CALL MXCOPYPTRTOREAL8(WT,%VAL(WTP),MM*NN)

      CALL REMEZF ( NFILT, NEG, NBANDS, NGRID, 
     1     %VAL(EP), %VAL(GRIDP), %VAL(DESP), %VAL(WTP), 
     2     %VAL(AD), %VAL(X), %VAL(Y), %VAL(ALPHA), 
     4     %VAL(A), %VAL(P), %VAL(Q), 
     5     %VAL(HP), %VAL(ERR), %VAL(IEXT) ) 

C       Create MATLAB output arrays and copy FORTRAN arrays into them:
      NFCNS = NFILT/2
      IF((NFILT - 2*NFCNS).EQ.1) NFCNS = NFCNS + 1
      PLHS(1) = MXCREATEFULL(NFCNS, 1, 0)
      PLHS(2) = MXCREATEFULL(1, 1, 0)
      PLHS(3) = MXCREATEFULL(((NFILT+1)/2+3), 1, 0)

      CALL MXCOPYREAL8TOPTR(%VAL(HP), mxGetPr(PLHS(1)), NFCNS)
      CALL MXCOPYREAL8TOPTR(%VAL(ERR), mxGetPr(PLHS(2)), 1)
      CALL MXCOPYREAL8TOPTR(%VAL(IEXT), mxGetPr(PLHS(3)), 
     +   ((NFILT+1)/2+3)  )

      RETURN
      END

