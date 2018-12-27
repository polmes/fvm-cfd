clear;clc;
% Fluid setup
mu=0.1;%1.3e-3;

% Mesh setup
L=1;
X=[0 1];
Y=[0 1];
Nx=10;
Ny=10;
mesh=msh.UniformMesh(X, Y, Nx, Ny);

% Simulation setup
uvi=zeros(2,Nx*Ny);
uvi(2,(-1:1)+round(0.5*Nx*Ny-0.5*Nx+1))=1;

T=[0 0.05];
tn=5000;
itsave=200;
[uvt,t]=integration.explicit(mesh,uvi,mu,T,tn,itsave);

% %% Create video
% %frames=zeros(floor(tn/itsave));
% for ti=size(uvt,1):-1:1
% 	h=plotQuiver(mesh,squeeze(uvt(ti,:,:)),0.3);
% 	drawnow;
% 	frames(ti)=getframe(h);
% 	close(h);
% end
% 
% fig=figure;
% movie(fig,frames,5);
% 
% %% Write to file
% vw = VideoWriter('v1.avi','Motion JPEG AVI');
% vw.Quality = 95;
% vw.FrameRate = 10;
% open(vw);
% writeVideo(vw,frames);
% close(vw);