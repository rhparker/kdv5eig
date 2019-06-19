!
! localized pulses of the Kdv5
!

subroutine func(ndim,u,icp,par,ijac,f,dfdu,dfdp)

	implicit none
	integer, intent(in) :: ndim, ijac, icp(*)
	double precision, intent(in) :: u(ndim), par(*)
	double precision, intent(out) :: f(ndim)
	double precision, intent(inout) :: dfdu(ndim,*), dfdp(ndim,*)

	double precision c
	double precision L
	double precision eps
	double precision q1,q2,p1,p2
	double precision dq1,dq2,dp1,dp2
	double precision v1,v2,v3,v4,v5
	double precision w1,w2,w3,w4,w5
	double precision alpha, beta
	integer j
  
	c = par(1)
	eps = par(2)
	L = par(3)
	alpha = par(4)
	beta = par(5)

	q1 = u(1)
	q2 = u(2)
	p1 = u(3)
	p2 = u(4)

	dq1 = q1*q1 - c*q1;
	dq2 = p1 - q2;
	dp1 = q2;
	dp2 = p2;
  
	f(1) = dp1  + eps*dq1
	f(2) = dp2  + eps*dq2
	f(3) = -dq1 + eps*dp1
 	f(4) = -dq2 + eps*dp2

 	if (ndim > 4) then
		v1 = u(5)
		v2 = u(6)
		v3 = u(7)
		v4 = u(8)
		v5 = u(9)
		w1 = u(10)
		w2 = u(11)
		w3 = u(12)
		w4 = u(13)
		w5 = u(14)
	 	f(5) = v2
	 	f(6) = v3
	 	f(7) = v4
	 	f(8) = v5
	 	f(9) = v4 - c*v2 + 2*q1*v2 + 2*q2*v1 + alpha*v1 - beta*w1;
	 	f(10) = w2
	 	f(11) = w3
	 	f(12) = w4
	 	f(13) = w5
 		f(14) = w4 - c*w2 + 2*q1*w2 + 2*q2*w1 + beta*v1 + alpha*w1;
	 end if

	do j=1,ndim
		f(j) = 2*L*f(j)
	end do

end subroutine func

!---------------------------------------------------------------------- 

subroutine stpnt(ndim,u,par,t)

	implicit none
	integer, intent(in) :: ndim
	double precision, intent(inout) :: u(ndim), par(*)
	double precision, intent(in) :: t

	! par(1)  = 36.0/169;		! wave speed (for exact solution)
	par(1)  = 20;			! wave speed
	par(2)  = 0;			! small parameter for Hamiltonian system
	par(3)  = 14;			! domain length L
	par(4)  = 0;			! real part eigenvalue		
	par(5)  = 0.2168;		! imag part eigenvalue
	par(6)  = 1;			! dummy parameter
 
end subroutine stpnt

!---------------------------------------------------------------------- 

subroutine bcnd(ndim,par,icp,nbc,u0,u1,fb,ijac,dbc)

	implicit none
	integer, intent(in) :: ndim, icp(*), nbc, ijac
	double precision, intent(in) :: par(*), u0(ndim), u1(ndim)
	double precision, intent(out) :: fb(nbc)
	double precision, intent(inout) :: dbc(nbc,*)

	integer j
	! boundary conditions
	do j=1,ndim
		fb(j) = u0(j) - u1(j)
	end do
	
end subroutine bcnd

!---------------------------------------------------------------------- 

subroutine icnd(ndim,par,icp,nint,u,uold,udot,upold,fi,ijac,dint)

	implicit none
	integer, intent(in) :: ndim, icp(*), nint, ijac
	double precision, intent(in) :: par(*)
	double precision, intent(in) :: u(ndim), uold(ndim), udot(ndim), upold(ndim)
	double precision, intent(out) :: fi(nint)
	double precision, intent(inout) :: dint(nint,*)

	fi(1) = upold(1)*(u(1)-uold(1))		! phase condition
	if (nint > 1) then
		fi(2) = u(5)*u(5) + u(10)*u(10) - 1.0
		fi(3) = uold(5)*u(10) + uold(10)*u(5)
	!	fi(2) = uold(5)*u(5) - 1.0
	end if
!	fi(2) = u(1)*u(1) - par(4)			! L^2 norm

end subroutine icnd

!---------------------------------------------------------------------- 

subroutine pvls
end subroutine pvls

subroutine fopt
end subroutine fopt

!---------------------------------------------------------------------- 
