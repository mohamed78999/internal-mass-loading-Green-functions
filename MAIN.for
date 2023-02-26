      PROGRAM MAIN
      IMPLICIT REAL*8(A-H,O-Z)
      IMPLICIT INTEGER*8(I-N)
      REAL*8 LAMDAC,LAMI,MUI
      CHARACTER*30 FLINE,LOVESS,LOVEVD,LOVEVT,LOVEHT,FINITS,FMODEL
      COMMON    /ABC/ CONSTA,CONSTB,CONSTC,FREQ,PAI
      COMMON    /MDI/   RADI, STEP, RHOI, LAMI, MUI, GRAVI
      COMMON    /NUM/ RHOC,LAMDAC,GRAVIS,RADIS,GNEWTN,RHOA,SURFMU,SM,SL

      RHOC   = 13.08848D0
      LAMDAC = 13080.0*1.D9
      GRAVIS = 981.56D0
      RADIS  = 6371.0*1.D5
      GNEWTN = 6.67D-8
      PAI    = 3.14159265358979D0
      FREQ   = 0.D0
      SM     = 266.0D0
      SL     = 342.0D0
      SURFMU = SM/LAMDAC*1.D9

      CONSTA = GRAVIS**2/(4.D0*PAI*LAMDAC*GNEWTN)
      CONSTB = 4.D0*PAI*GNEWTN*RHOC*RADIS/GRAVIS
      CONSTC = RHOC*GRAVIS*RADIS/LAMDAC

      OPEN(100,FILE='input.dat',ACTION='READ')
      READ (100,*)
      READ (100,*) DEP
      PRINT 400, DEP
 400  FORMAT ('      DEPTH OF SOURCE = ', F8.3)
      READ (100,*)
      READ (100,*) DEFORM
      PRINT 401, DEFORM
 401  FORMAT ('      DEPTH OF DEFORMATION = ', F8.3)
      READ (100,*)
      READ (100,*) LOVESS
      READ (100,*) LOVEVD
      READ (100,*) LOVEVT
      READ (100,*) LOVEHT
      READ (100,*) FMODEL
      CLOSE(100)
      CALL MODEL(FMODEL)

      NUP = (10.0 * 6371.0) / ABS(DEP-DEFORM)
      IF (NUP.GT.45000) NUP=45000

      OPEN(701,FILE=LOVESS)
      OPEN(702,FILE=LOVEVD)
      OPEN(703,FILE=LOVEVT)
      OPEN(704,FILE=LOVEHT)
      CALL LOVE0(DEP,DEFORM,DLA,DMU)
      CALL LOVE1(DEP,DEFORM)
C      DO J = 2, 385
       DO J = 2, 385
        IF(J.LE.100)  N=J
        IF(J.GT.100 .AND. J.LE.195)  N=100+20*(J-100)
        IF(J.GT.195 .AND. J.LE.255)  N=2000+50*(J-195)
        IF(J.GT.255 .AND. J.LE.305)  N=5000+100*(J-255)
        IF(J.GT.305)  N=10000+500*(J-305)
        CALL LOVE2(N,DEP,DEFORM)
        IF(NUP.GE.N) M=J
        IF(NUP.GE.N) MD=N
      END DO
      CLOSE(704)
      CLOSE(703)
      CLOSE(702)
      CLOSE(701)


      WRITE(*,'(2I6)')	    M,MD
      WRITE(*,'(2E12.4)')	DLA,DMU

      !CALL LOVE(DEP,DEFORM,M-1)

      !CALL GREEN0KM(DEP,DEFORM,MD,DLA,DMU)

      call yfile2green(LOVEHT,DEP)




      END PROGRAM MAIN

