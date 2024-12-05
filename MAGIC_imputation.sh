###LAYER 1###

##subsetting the parental .vcf file##
#parent_pairs="parent_pairs.txt"

module load cluster/bcftools/1.18

#input VCF file
VCF_FILE="parent.vcf"

#output directory to store the subsetted VCFs
OUTPUT_DIR="layer1_subset_vcfs"
mkdir -p $OUTPUT_DIR

#read through the parent pairs file and create a subset for each pair
while read -r parent1 parent2; do
    # Create a filename based on the parent pair
    OUTPUT_VCF="${OUTPUT_DIR}/subset_${parent1}_${parent2}.vcf"

    #extract only the columns for the parents in the VCF file
    bcftools view -s $parent1,$parent2 $VCF_FILE -o $OUTPUT_VCF
    echo "Subset for ${parent1} and ${parent2} created: $OUTPUT_VCF"
done < "$parent_pairs"

##subsetting the genotype .vcf file for layer 1##
#layer1_geno_list.txt (space delimited)
     

#genotyping VCF file
geno_vcf="layer1_geno.vcf"

#file containing list of sample groups
sample_list="layer1_geno_list.txt"

#loop through each line in the sample list
while read -r line; do
    #clean up the line (remove leading/trailing whitespace and replace spaces with underscores)
    sample_group=$(echo "$line" | tr -s ' ' '_')

    #run bcftools to subset the VCF by the sample group
    bcftools view -s $(echo "$line" | tr ' ' ',') "$input_vcf" -o "output_subset_${sample_group}.vcf"
done < "$sample_list"

##Beagle imputation##
#Designate a list which contains @r values (reference parent file) and @g values (genotyping file)
#pair_list_layer1.txt

pairs_list_file="pair_list_layer1.txt"

#iterate over each line in the list file
while IFS=" " read -r r g; do
    #run the Beagle command for each pair
    java -Xmx52g -jar beagle.jar ref="${r}.vcf" gt="${g}.vcf" out="${g}.imputed.vcf" ne=[fixed] map=[fixed]
done < "$pairs_list_file"


###LAYER 2####

###concatenating two imputed .vcf files* (depending on ) which will serve as the parents for the four-way cross providing a list file
#four_way_pairs.txt

module load cluster/bcftools/1.18

#define the path to the list file
list_file="four_way_pairs.txt"

#loop over each line in the list file
while read -r pair; do
  #split the pair into two variables (vcf1 and vcf2)
  set -- $pair
  vcf1=$1
  vcf2=$2

  #define the output filename
  output="merged_${vcf1%.*}_${vcf2%.*}.vcf"

  #merge the VCF files using bcftools
  bcftools merge "$vcf1" "$vcf2" -o "$output"
done < "$list_file"

##subsetting the genotype .vcf file for layer 2##
#layer2_geno_list.txt (space delimited)
     

#genotyping VCF file
geno_vcf="layer2_geno.vcf"

#file containing list of sample groups
sample_list="layer2_geno_list.txt"

#loop through each line in the sample list
while read -r line; do
    # Clean up the line (remove leading/trailing whitespace and replace spaces with underscores)
    sample_group=$(echo "$line" | tr -s ' ' '_')

    #run bcftools to subset the VCF by the sample group
    bcftools view -s $(echo "$line" | tr ' ' ',') "$input_vcf" -o "output_subset_${sample_group}.vcf"
done < "$sample_list"

##Beagle imputation##
#Designate a list which contains @r values (reference parent file) and @g values (genotyping file)
#pair_list_layer2.txt

pairs_list_file="pair_list_layer2.txt"

#iterate over each line in the list file
while IFS=" " read -r r g; do
    #run the Beagle command for each pair
    java -Xmx52g -jar beagle.jar ref="${r}.vcf" gt="${g}.vcf" out="${g}.imputed.vcf" ne=[fixed] map=[fixed]
done < "$pairs_list_file"


###LAYER 3###

##concatenating two imputed .vcf files which will serve as the parents for the eight-way cross providing a list file##
#eight_way_pairs.txt


module load cluster/bcftools/1.18

#define the path to the list file
list_file="four_way_pairs.txt"

#loop over each line in the list file
while read -r pair; do
  #split the pair into two variables (vcf1 and vcf2)
  set -- $pair
  vcf1=$1
  vcf2=$2

  #define the output filename
  output="merged_${vcf1%.*}_${vcf2%.*}.vcf"

  #merge the VCF files using bcftools
  bcftools merge "$vcf1" "$vcf2" -o "$output"
done < "$list_file"

##subsetting the genotype .vcf file for layer 3##
#layer3_geno_list.txt (space delimited)     

#genotyping VCF file
geno_vcf="layer3_geno.vcf"

#file containing list of sample groups
sample_list="layer3_geno_list.txt"

#loop through each line in the sample list
while read -r line; do
    #clean up the line (remove leading/trailing whitespace and replace spaces with underscores)
    sample_group=$(echo "$line" | tr -s ' ' '_')

    #run bcftools to subset the VCF by the sample group
    bcftools view -s $(echo "$line" | tr ' ' ',') "$input_vcf" -o "output_subset_${sample_group}.vcf"
done < "$sample_list"

##Beagle imputation##
#Designate a list which contains @r values (reference parent file) and @g values (genotyping file)
#pair_list_layer3.txt

pairs_list_file="pair_list_layer3.txt"

#iterate over each line in the list file
while IFS=" " read -r r g; do
    #run the Beagle command for each pair
    java -Xmx52g -jar beagle.jar ref="${r}.vcf" gt="${g}.vcf" out="${g}.imputed.vcf" ne=[fixed] map=[fixed]
done < "$pairs_list_file"


###LAYER 4###

##concatenating two imputed .vcf files which will serve as the parents for the sixteen-way cross providing a list file
#sixteen_way_pairs.txt

module load cluster/bcftools/1.18

#define the path to the list file
list_file="sixteen_way_pairs.txt"

#loop over each line in the list file
while read -r pair; do
  # Split the pair into two variables (vcf1 and vcf2)
  set -- $pair
  vcf1=$1
  vcf2=$2

  #define the output filename
  output="merged_${vcf1%.*}_${vcf2%.*}.vcf"

  #merge the VCF files using bcftools
  bcftools merge "$vcf1" "$vcf2" -o "$output"
done < "$list_file"

##subsetting the genotype .vcf file for layer 3##
#layer4_geno_list.txt (space delimited)

#genotyping VCF file
geno_vcf="layer4_geno.vcf"

#file containing list of sample groups
sample_list="layer4_geno_list.txt"

#loop through each line in the sample list
while read -r line; do
    #clean up the line (remove leading/trailing whitespace and replace spaces with underscores)
    sample_group=$(echo "$line" | tr -s ' ' '_')

    #run bcftools to subset the VCF by the sample group
    bcftools view -s $(echo "$line" | tr ' ' ',') "$input_vcf" -o "output_subset_${sample_group}.vcf"
done < "$sample_list"

##Beagle imputation##
#Designate a list which contains @r values (reference parent file) and @g values (genotyping file)
#pair_list_layer4.txt


pairs_list_file="pair_list_layer4.txt"

#iterate over each line in the list file
while IFS=" " read -r r g; do
    #Run the Beagle command for each pair
    java -Xmx52g -jar beagle.jar ref="${r}.vcf" gt="${g}.vcf" out="${g}.imputed.vcf" ne=[fixed] map=[fixed]
done < "$pairs_list_file"