function [uvt,tr]= time_integr(mesh,uvi,mu,T,tn,itsave)

% Fluid Properties

t=linspace(T(1),T(2),tn+1);
dt=t(2:end)-t(1:end-1);

uvt=zeros(floor(tn/itsave)+1,size(uvi,1),size(uvi,2));

uv=uvi-mesh.cv.uvCorrection(mesh,uvi);
C=mesh.convective(uv);
D=mesh.diffusive(uv);
Rn=(-C+mu*D)./mesh.vol;
Ro=Rn;
uvt(1,:,:)=uv;
for k=1:size(dt,2)
	
	C=mesh.convective(uv);
	D=mesh.diffusive(uv);
	Rn=(-C+mu*D)./mesh.vol;
	uvnew=uv+dt(k)*(1.5*Rn-0.5*Ro);
	uvcorr=uvnew-mesh.cv.uvCorrection(mesh,uvnew);
	
	if(mod(k,itsave)==0)
		display(['Iteration ',num2str(k)]);
		uvt(floor(1+k/itsave),:,:)=uvcorr;
	end
	if(~isempty(find(isnan(uvcorr))))
		display(['NaN exception at k=',num2str(k),', t=',num2str(t(k))])
		k
		return
	end
	uv=uvcorr;
	Ro=Rn;
end

tr=t([1,find(mod(1:k,itsave)==0)]);