/*
INPUT: file de datos casos diarios N[i]
OUTPUT: N[i],rho[i],rho7[i],IA14;
*/
#include <fstream>
#include <iostream>
#include <vector>
using namespace std;

int main(int argc, char **argv)
{
	//cout << "input file=" << argv[1] << endl;
	ifstream fin(argv[1]);

	vector<int> N;

	int n;
	while(fin.good())
	{
		fin >> n;
		N.push_back(n);
	};
	int Nmax=N.size();
	cout << "Nmax=" << Nmax << std::endl;
	
	// extrapolacion 14 dias para adelante
	double promedio=0.0;
	for(int i=Nmax-7;i<Nmax;i++) promedio+=N[i];
	promedio*=1.0/7.0;	
	for(int i=0;i<14;i++) N.push_back(promedio);
	
	vector<double> rho;
	vector<double> rhoalt;
	for(int i=0;i<N.size();i++)
	{	
		double Nim8=(i>=8)?(N[i-8]):(0.0);
		double Nim7=(i>=7)?(N[i-7]):(0.0);
		double Nim6=(i>=6)?(N[i-6]):(0.0);
		double Nim5=(i>=5)?(N[i-5]):(0.0);
		double Nim4=(i>=4)?(N[i-4]):(0.0);
		double Nim3=(i>=3)?(N[i-3]):(0.0);
		double Nim2=(i>=2)?(N[i-2]):(0.0);
		double Nim1=(i>=1)?(N[i-1]):(0.0);
		double Ni=N[i];
		double Nip1=(i<N.size()-1)?(N[i+1]):(0.0);
		double Nip2=(i<N.size()-2)?(N[i+2]):(0.0);
		double Nip3=(i<N.size()-3)?(N[i+3]):(0.0);
			
		double numerador=(Nim1+Ni+Nip1);	
		double denominador=(Nim6+Nim5+Nim4);	

		if(denominador==0) denominador=1.0;

		double inc=numerador/denominador;
		inc=(inc>4.0)?(4.0):(inc);//saturacion?
		rho.push_back(inc);	

		
		////////// alternativo 1
		
		denominador=(Nim6+2.*Nim5+3.*Nim4+2.*Nim3+Nim2);
		if(denominador==0) denominador=1.0;
		
		inc = 3.0*numerador/denominador;
		inc=(inc>4.0)?(4.0):(inc);//saturacion?
		rhoalt.push_back(inc);	
		

		////////// alternativo 2

		/*numerador = Nim2+Nim1+Ni+Nip1+Nip2;
		denominador=(Nim7 + 2.0*Nim6 +3.0*Nim5 +4.0*Nim4 +3.0*Nim3 +2.0*Nim2 +Nim1);
		if(denominador==0) denominador=1.0;
		inc = 3.0*numerador/denominador;
		inc=(inc>4.0)?(4.0):(inc);//saturacion?
		rhoalt.push_back(inc);*/	

		////////// alternativo 3
		/*numerador = Ni;
		denominador=(Nim5 +Nim4 +Nim3);
		if(denominador==0) denominador=1.0;
		inc = 3.0*numerador/denominador;
		inc=(inc>4.0)?(4.0):(inc);//saturacion?
		rhoalt.push_back(inc);	
		*/
		////////// alternativo 4

		/*numerador = Nim3+Nim2+Nim1+Ni+Nip1+Nip2+Nip3;
		denominador=(Nim8 + 2.*Nim7 + 3.*Nim6 + 4.*Nim5 + 5.*Nim4 + 4.*Nim3 + 3.*Nim2 + 2.*Nim1 + Ni);
		if(denominador==0) denominador=1.0;
		inc = 3.0*numerador/denominador;
		inc=(inc>4.0)?(4.0):(inc);//saturacion?
		rhoalt.push_back(inc);	
		*/


	}	

	vector<double> rho7;
	vector<double> rho7alt;
	for(int i=0;i<Nmax;i++)
	{	
		double rhoim3=(i>=3)?(rho[i-3]):(rho[0]);
		double rhoim2=(i>=2)?(rho[i-2]):(rho[0]);
		double rhoim1=(i>=1)?(rho[i-1]):(rho[0]);
		double rhoi = (rho[i]>0.0)?(rho[i]):(0.0);
		double rhoip3=(i<N.size()-3 && rho[i+3]>0.0)?(rho[i+3]):(0.0);
		double rhoip2=(i<N.size()-2 && rho[i+2]>0.0)?(rho[i+2]):(0.0);
		double rhoip1=(i<N.size()-1 && rho[i+1]>0.0)?(rho[i+1]):(0.0);
		
		double inc=(rhoim3+rhoim2+rhoim1+rhoi+rhoip1+rhoip2+rhoip3)/7.0;		
		rho7.push_back(inc);

		/*double rhoim6=(i>=6)?(rho[i-6]):(rho[0]);
		double rhoim5=(i>=5)?(rho[i-5]):(rho[0]);
		double rhoim4=(i>=4)?(rho[i-4]):(rho[0]);
		inc=(1*rhoim6+2*rhoim5+3*rhoim4+4*rhoim3+5*rhoim2+6*rhoim1+7*rhoi)/28.0;*/
		
		double rhoaltim3=(i>=3)?(rhoalt[i-3]):(rhoalt[0]);
		double rhoaltim2=(i>=2)?(rhoalt[i-2]):(rhoalt[0]);
		double rhoaltim1=(i>=1)?(rhoalt[i-1]):(rhoalt[0]);
		double rhoalti = (rhoalt[i]>0.0)?(rhoalt[i]):(0.0);
		double rhoaltip3=(i<N.size()-3 && rhoalt[i+3]>0.0)?(rhoalt[i+3]):(0.0);
		double rhoaltip2=(i<N.size()-2 && rhoalt[i+2]>0.0)?(rhoalt[i+2]):(0.0);
		double rhoaltip1=(i<N.size()-1 && rhoalt[i+1]>0.0)?(rhoalt[i+1]):(0.0);
		inc=(rhoaltim3+rhoaltim2+rhoaltim1+rhoalti+rhoaltip1+rhoaltip2+rhoaltip3)/7.0;		
		//inc=(rhoaltim3+rhoaltim2+rhoaltim1+rhoalti)/4.0;		
		rho7alt.push_back(inc);
	}	

	ofstream x1out("x1.js"); x1out << "var x1=[" << endl;	
	ofstream y1out("y1.js"); y1out << "var y1=[" << endl;	
	ofstream t1out("t1.js"); t1out << "var t1=[" << endl;	

	for(int i=14;i<Nmax;i++)
	{
		double IA14=0.0;
		for(int j=0;j<14;j++) IA14+=(i-j>=0)?(N[i-j]):(0.0);
		
		cout << N[i] << "," << rho[i] << "," << rho7[i] << "," << IA14 << "," << i << "," 
		<< rho7alt[i] << "," << rhoalt[i] << endl;

		x1out <<  IA14 << ",";
		y1out <<  rho7[i]  << ",";
		t1out << "\"" << "t=" << i  << "\"" << ",";
	}		
	x1out <<  "];" << endl;
	y1out <<  "];" << endl;
	t1out <<  "];" << endl;
		
	return 0;
}
