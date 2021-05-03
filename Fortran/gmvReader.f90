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
    real(8),dimension(:,:),allocatable :: varVal
  end type
  type cellData
    character(len=100)  :: varName
    integer             :: varType
    integer,dimension(:,:),allocatable :: varVal
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

SUBROUTINE parseVals(oFile,lBuffer,strVar,intVar)
  implicit none
  character(len=100), intent(inout)  :: lBuffer
  integer, intent(out)            :: intVar
  character(len=100), intent(out) :: strVar
  integer, intent(in)             :: oFile
  integer  :: split=0
  
  read(oFile,"(a)") lBuffer
  write(*,"(a)") lBuffer
  split=scan(trim(lBuffer),' ',.TRUE.)
  
  read(lBuffer(1:split),"(a)"),strVar
  read(lBuffer(split:len(lBuffer)),"(i10)"),intVar
END SUBROUTINE

PROGRAM gmvReader
  use myVars, only : fshaft_trac, fshaft_cons, nodeData, celldata
  use kivaVars, only : ngmv,numcellsa,numvertsa
  implicit none
  
  integer :: oFile=10,iostatus
  integer :: jump,lStep,ierr,nSteps,i
  integer, allocatable :: iStep(:)
  type(nodeData),dimension(:),allocatable :: work
  type(cellData),dimension(:),allocatable :: work2
  character(len=100) filename,lBuffer

  filename='plotgmv'//char(ngmv/10+48)//char(mod(ngmv,10)+48)
  
  allocate(work(50),work2(50))
  open(unit=oFile,file=filename,iostat=iostatus, &
          status='old',form='formatted',action='READ')
  read(oFile,*)
!Parse the name and values in the file
! Read in the nodes
  i=1
  call parseVals(oFile,lBuffer,work(i)%varName,numvertsa)
  work(i)%varType=numvertsa
  allocate(work(i)%varVal(numvertsa,3))
  read(oFile,"(1p,10e13.5)") work(i)%varVal(:,1)
  read(oFile,"(1p,10e13.5)") work(i)%varVal(:,2)
  read(oFile,"(1p,10e13.5)") work(i)%varVal(:,3)
! read cells
  call parseVals(oFile,lBuffer, work2(1)%varName, numcellsa)
  allocate(work2(1)%varVal(numcellsa,8))
  read(oFile,"(10X,8I7)") work2(1)%varVal
! read velocity
  i=2
  call parseVals(oFile,lBuffer,work(i)%varName,work(i)%varType)
  allocate(work(i)%varVal(numvertsa,3))
  write(*,"(a)") lBuffer
  read(oFile,"(1p,10e13.5)") work(i)%varVal(:,1)
  read(oFile,"(1p,10e13.5)") work(i)%varVal(:,2)
  read(oFile,"(1p,10e13.5)") work(i)%varVal(:,3)
! Loop for vars
  do 10 i = 3, 50
  write(*,"('Cycle i: 'I7)") i
  call parseVals(oFile,lBuffer, work(i)%varName, work(i)%varType)
  if (trim(lBuffer)=='variable') then
    call parseVals(oFile,lBuffer, work(i)%varName, work(i)%varType)
  end if
  if (trim(lBuffer)=='endvars') then
    write(*,"(a)") 'endvars condition'
  end if
!  write(*,"(a)") work(i)%varName
!  write(*,"(I7)") work(i)%varType
  allocate(work(i)%varVal(numcellsa,1))
  read(oFile,"(1p,10e13.5)") work(i)%varVal
10  continue  
  
!  (x(iverti(i)),i=1,numvertsa)

  close(oFile)  
END PROGRAM gmvReader
