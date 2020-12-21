MODULE kivaVars
  implicit none
  integer :: ngmv
  integer :: numcellsa,numvertsa
  real(8),allocatable :: time(:), theta(:)
END MODULE

MODULE myVars
  implicit none                        
  real(8),allocatable :: fshaft_trac(:,:), fshaft_cons(:,:)
  type nodeData
    character(len=100)  :: varName
    integer             :: varType
    real(8),allocatable :: varValX(:),varValY(:),varValZ(:)
  end type
  type cellData
    character(len=100)  :: varName
    integer             :: varType
    real(8),allocatable :: varVal(:)
  end type
END MODULE

SUBROUTINE parseData(nData,oVar,iFile)
  use myvars
  type(nodeData), intent(out) :: oVar
  integer, intent(in) :: nData,iFile
!  open(iFile, file=fName, status='old')!See iosol.f90
!  read(iFile,"(4ES17.8)") time(i), theta(i)
!  read(iFile,"(4ES17.8)") fshaft_cons(i,1), fshaft_cons(i,2), fshaft_cons(i,3)
  
!  read(iFile,"('nodes   ',i10)") netvtxs
!  read(iFile,"(1p,10e13.5)") (x(iverti(i)),i=1,numvertsa)
!  read(iFile,"(1p,10e13.5)") (y(iverti(i)),i=1,numvertsa)
!  read(iFile,"(1p,10e13.5)") (z(iverti(i)),i=1,numvertsa)
!  close(iFile)
END SUBROUTINE 

SUBROUTINE parseVals(lBuffer,strVar,intVar)
  implicit none
  character(len=100), intent(in)  :: lBuffer
  integer, intent(out)            :: intVar
  character(len=100), intent(out) :: strVar
  
  integer  :: split=0
  
  split=scan(trim(lBuffer),' ',.TRUE.)
  
  read(lBuffer(1:split),"(a)"),strVar
  read(lBuffer(split:len(lBuffer)),"(i10)"),intVar
END SUBROUTINE

PROGRAM gmvReader
  use myVars, only : fshaft_trac, fshaft_cons, nodeData
  use kivaVars, only : ngmv,numcellsa,numvertsa
  implicit none
  
  integer :: oFile=10,iostatus
  integer :: jump,lStep,ierr,nSteps,i
  integer, allocatable :: iStep(:)
  type(nodeData) :: work
  type(nodeData),dimension(:),allocatable :: work2
  character(len=100) filename,lBuffer

  filename='plotgmv'//char(ngmv/10+48)//char(mod(ngmv,10)+48)
  
  allocate(work2(60))
  
  open(unit=oFile,file=filename,iostat=iostatus, &
          status='old',form='formatted',action='READ')
  read(oFile,*)
  read(oFile,"(a)") lBuffer
!Parse the name and values in the file
  call parseVals(lBuffer,work%varName,work%varType)
!Read in the nodes
  allocate(work%varValX(work%varType),work%varValY(work%varType),work%varValZ(work%varType))
  read(oFile,"(1p,10e13.5)") work%varValX
  read(oFile,"(1p,10e13.5)") work%varValY
  read(oFile,"(1p,10e13.5)") work%varValZ
  read(oFile,"(a)") lBuffer
  write(*,"(1p,10e13.5)")work%varValX(1)
  write(*,"(1p,10e13.5)")work%varValZ(ubound(work%varValz))
  write(*,"(a)") lBuffer
  

  close(oFile)  
END PROGRAM gmvReader
