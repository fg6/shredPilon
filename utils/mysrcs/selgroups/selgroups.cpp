#include "../myinc/macro.h"

int calc(void);

static int size=10; //Mb


int main(int argc, char *argv[])
{ 

  if (argc == 1) {
   fprintf(stderr, "Usage: %s <reads.fq/fa>\n", argv[0]);
   return 1;
  }	
  if((fp = gzopen(argv[1],"r")) == NULL){ 
    printf("ERROR main:: missing input file  !! \n");
    return 1;
  }
  if (argc == 3) size= to_int(argv[2]);

  int err=1;

  int isfq=fasttype(argv[1]);
  if(!isfq)
    err=readfasta(argv[1],1); 
  else
    err=readfastq(argv[1],1);
 

  if(!err)calc();  
 

  return 0;
}


// ---------------------------------------- //
int calc()
// ---------------------------------------- //
{
  sort(rlen.begin(),  rlen.end(), std::greater<int>());

  int n=rlen.size();
  int max=rlen[0];                 	
  int bases = accumulate(rlen.begin(), rlen.end(), 0);

  int group_size=size*1000000;
  long int tsum=0;
  vector< vector<string>> groups(0,vector<string>(0));
  vector<int> groups_sizes;

  int group=0;
  groups.push_back(std::vector<std::string>()); 
  for(int ctg=0; ctg<rlen.size(); ctg++){
    if(tsum > group_size){
      //cout << "   group " << group << " done " << tsum << endl;
      group++;
      groups.push_back(std::vector<std::string>());
      groups_sizes.push_back(tsum);
      tsum=0;
    } 
    tsum+=rlen[ctg];
    groups[group].push_back(rname[ctg]);
    //cout << " group " << group <<  " " << rname[ctg] << " "  << tsum << endl;
    if(ctg==rlen.size()-1){
      //cout << "   group " << group << " done " << tsum << endl;
      groups_sizes.push_back(tsum);   
    }
  }
  




  std::ofstream myfile;
  string thisname="groups.list";
  myfile.open(thisname.c_str());

  std::stringstream cprint;
  for (int g=0; g<=group; g++){
    int t=0;
    if(g>0)cprint << "    " << groups_sizes[g-1] << endl;
    for (int gg=0; gg<groups[g].size(); gg++){
      if(t>0)cprint << ",";
      if(t>0)myfile << ",";
       cprint << groups[g][gg] ;
       myfile << groups[g][gg] ;
      t++;
    }
     myfile << endl;
     if(g==group)cprint << "    " << groups_sizes[g];
  }
  std::string s = cprint.str();
  //cout << s << endl;

  
  myfile.close();



  return 0;
}

