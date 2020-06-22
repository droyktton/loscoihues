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

	//for(int i=0;i<N.size();i++)
	//cout << N[i] << endl;	
		
	vector<double> rho;
	for(int i=0;i<N.size();i++)
	{	
		double Nim6=(i>=6)?(N[i-6]):(0.0);
		double Nim5=(i>=5)?(N[i-5]):(0.0);
		double Nim4=(i>=4)?(N[i-4]):(0.0);
		double Nim1=(i>=1)?(N[i-1]):(0.0);
		double Nip1=(i<N.size()-1)?(N[i+1]):(0.0);
		double Ni=N[i];
			
		double inc=(Nim1+Ni+Nip1)/(Nim6+Nim5+Nim4);
		if((Nim6+Nim5+Nim4)==0) inc=-1.0;		

		rho.push_back(inc);	
	}	

	vector<double> rho7;
	for(int i=0;i<N.size();i++)
	{	
		double rhoim3=(i>=3)?(rho[i-3]):(0.0);
		double rhoim2=(i>=2)?(rho[i-2]):(0.0);
		double rhoim1=(i>=1)?(rho[i-1]):(0.0);
		double rhoi = rho[i];
		double rhoip3=(i<N.size()-3)?(rho[i+3]):(0.0);
		double rhoip2=(i<N.size()-2)?(rho[i+2]):(0.0);
		double rhoip1=(i<N.size()-1)?(rho[i+1]):(0.0);
		
		double inc=(rhoim3+rhoim2+rhoim1+rhoi+rhoip1+rhoip2+rhoip3)/7.0;		

		rho7.push_back(inc);
	}	

	ofstream x1out("x1.js"); x1out << "var x1=[" << endl;	
	ofstream y1out("y1.js"); y1out << "var y1=[" << endl;	
	ofstream t1out("t1.js"); t1out << "var t1=[" << endl;	

	for(int i=7;i<N.size();i++)
	{
		double IA14=0.0;
		for(int j=0;j<14;j++) IA14+=(i-j>=0)?N[i-j]:0.0;
		cout << N[i] << " " << rho[i] << " " << rho7[i] << " " << IA14 << " " << i << endl;

		x1out <<  IA14 << ",";
		y1out <<  rho7[i]  << ",";
		t1out << "\"" << "t=" << i  << "\"" << ",";
	}		
	x1out <<  "];" << endl;
	y1out <<  "];" << endl;
	t1out <<  "];" << endl;
		
	return 0;
}
