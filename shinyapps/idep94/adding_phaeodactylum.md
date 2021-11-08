1. Open `convertIDs.db`, the mapping table is used to select the good species pathway 

2. Delete all row about phaeo in mapping table with 
    ```sql
    DELETE FROM mapping WHERE species = 499.0
    ```
    as it is from an older annotation

3. For each phatr3 gene insert it in **UPPERCASE** in mapping with:
    ```sql
    INSERT INTO mapping(id, ens, species, idType) VALUES (PHATR3_J0000, PHATR3_J0000, 499.0, 1)
    ```
    This gene name will be the default one in all iDEP, and will correspond to ens column

4. For each alternative name of the gene, insert it like this (as the id column) with the correct number on the last column
    ```sql
    INSERT INTO mapping(id, ens, species, idType) VALUES (B5Y4P6, PHATR3_J0000, 499.0, 1035)
    ```
    | idType   | number |
    |----------|--------|
    | uniprot  | 1035   |
    | ncbi     | 31     |
    | kegg     | 314    |

5. Open `STRING.2850.Phaeodactylum__Phaeodactylum_tricornutum.db` in `pathwayDB` folder
   
6. Rename all PHATR2 gene name in PHATR3 when correspondance is present

7. Create GO info row in pathwayInfo with:
    ```sql
    INSERT INTO pathwayInfo (id, name, description, n) VALUES (
        GO:0008270,	
        GOMF.STRING_v11_2850_STRINGid_GO:0008270_zinc_ion_binding,
        zinc_ion_binding,
        269
    )
    ```

8. For each gene, make link with annoted GO using:
    ```sql
    INSERT INTO pathway (gene, pathwayID, category, IEA) VALUES (PHATR3_J18029, GO:0005622, GOCC, "NA")
    ```

9. Create KEGG info row in pathwayInfo with:
    ```sql
    INSERT INTO pathwayInfo (id, name, description, n, memo) VALUES (
        "path:pti05221",  "KEGG.STRING_v11_2850_STRINGid_path:pti05221_Acute_myeloid_leukemia", 
        "Acute myeloid leukemia", 
        3, 
        "https://www.genome.jp/kegg-bin/show_pathway?pti05221"
    )
    ```

10. For each gene, make link with annoted KEGG using
    ```sql
    INSERT INTO pathway (gene, pathwayID, category, IEA) VALUES ("PHATR3_J49894", "path:pti05221", "KEGG", "NA")
    ```

11. Add KEGG in categories table with:
    ```sql
    INSERT INTO Categories(categories, Count) VALUES ('KEGG', kegg_annotation_number)
    ```

12. Add the following line in `data_go/KEGG_Species_ID.csv` 
    ```csv
    STRING.2850.Phaeodactylum,Phaeodactylum tricornutum genes (CCAP 1055/1),pti
    ```
Step 3 and 4 are done by script `add_phatr3_to_convertdb.py`

Step 6 to 11 are done by script `add_annotation_in_idep_pathwaydb.py`
