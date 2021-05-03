


      write(10,"('gmvinput ascii')")
! TODO: write var list
! TODO: write the time accepted by visit instead of the zone
! TODO: write the values in the order of varlist
! TODO: Define iface based on kiva's varnames
! TODO: 
! TODO: 
! TODO: 
! TODO: 
! TODO: 
! TODO: 
! TODO: 
! TODO: 

      write(10,"(1p,10e13.5)") (x(iverti(i)),i=1,numvertsa)
      write(10,"(1p,10e13.5)") (y(iverti(i)),i=1,numvertsa)
      write(10,"(1p,10e13.5)") (z(iverti(i)),i=1,numvertsa)
      do 20 i4a=1,numvertsa
         i4 = iverti(i4a)
         work(i4)=u(i4)
   20 continue
      write(10,"(1p,10e13.5)") (work(iverti(i)),i=1,numvertsa)
      do 20 i4a=1,numvertsa
         i4 = iverti(i4a)
         work(i4)=v(i4)
   20 continue
      write(10,"(1p,10e13.5)") (work(iverti(i)),i=1,numvertsa)
      
      do 20 i4a=1,numvertsa
         i4 = iverti(i4a)
         work(i4)=w(i4)
   20 continue
      write(10,"(1p,10e13.5)") (work(iverti(i)),i=1,numvertsa)
      write(10,"(1p,10e13.5)") (p(icelli(i)),i=1,numcellsa)
      write(10,"(1p,10e13.5)") (temp(icelli(i)),i=1,numcellsa)
      write(10,"(1p,10e13.5)") (ro(icelli(i)),i=1,numcellsa)
      write(10,"(1p,10e13.5)") (tke(icelli(i)),i=1,numcellsa)
      
      do 50 i4a=1,numcellsa
         i4c = icelli(i4a)
         epsden=eps(i4c)
         if (eps(i4c).eq.zero) epsden=one
         work(i4c)=cmueps*tke(i4c)*sqrt(tke(i4c))/epsden
   50 continue
!      write(10,"('scl      0')")
      write(10,"(1p,10e13.5)") (work(icelli(i)),i=1,numcellsa)
      
      if ((nrk .gt. 0).and.(trbchem .lt. 2)) then
      do 60 i4a=1,numcellsa
         i4c = icelli(i4a)
         spdi41=max(spd(i4c,1),zero)
         dente=fam(1,1)*spd(i4c,nspl+1)*mw(1)
         den=dente
         if(dente.le.zero) den=smallnum1
         work(i4c)=fam(2,1)*spdi41*mw(nspl+1)/den
         if(abs(work(i4c)).lt.tinynum) work(i4c)=zero
   60 continue
      write(10,"('er       0')")
      write(10,"(1p,10e13.5)") (work(icelli(i)),i=1,numcellsa)
      end if
! TODO: add chemical species support
