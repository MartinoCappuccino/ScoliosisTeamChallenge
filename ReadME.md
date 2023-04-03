The Ribbles software was developed to evaluate the rib deformity in scoliotic patients. 
From CT scans corresponding ribs from the right and left are compared. The output is a 
visualization of the ribcage where parts of ribs that are not or only slightly deformed 
are colored green. The stronger the deformation the more red a rib will be colored.


The Ribbles Software consists of five main functions and a Graphical User Interface (GUI):

GUI:
    To use the GUI all functions have to be added to the Matlab path. To install the "Ribbles" GUI one can use our installer included in this folder. Go through the steps and install the application.
    Once installed one can start "Ribbles" by searching in the search bar and starting the program.
    A window will appear where you can load peoperative and postoperative .nii files from the CT scans.

    Once the scan is loaded the button "Start Algorithm" can be pressed. 
    After that the calculations runs for a few minutes.

    Once the calculations are finished the ribcage with colored ribs are displayed. To the left of the 
    image checkmarks can be set to visualize centerlines of ribs and spine, the segmentations of ribs 
    and spine and which ribs are recognized as corresponding. (Note: some whole structures will always 
    overlap the centerlines).

    For a quick demo of our application it is advised to use patient 3 and 5 to see the best results. 
    Further tweaking of the algorithms is needed to improve the results for the different patients.



Function get_ribcage:
    Syntax:
        [pcribcage, ribcage, voxeldimensions, units]=get_ribcage(file_name, closing_kernel, opening_kernel, colorribcage)

    Description:
        Takes the nifti file of CT scan and returns the segmented ribcage as a pointcloud object and a 3D-Matrix

    Input-Arguments:
        file_name: string, path to nifti of CT scan
        closing_kernel: scalar, size of structural element for morphological closing during segmentation
        opening_kernel: scalar, size of structural element for morphological opening during segmentation
        colorribcage: 1x3 matrix of RGB colors (each element between 0 and 255) in which the ribcage will be displayed

    Output-Arguments:
        pcribcage: pointcloud object that contains the segmented ribcage
        ribcage: 3D-Matrix that contains the segmented ribcage
        voxeldimensions: 1 x 3 array with the lengths of one voxel in x y z directions
        units: string that specifies the unit (typically mm)



Function separate_ribcage:
    Syntax:
       [pcspinecenterline, pcspine, pcribs, ribs] = seperate_ribcage(ribcage, colorspine, colorribs)

    Description: 
        Takes a segmented ribcage and separates the spine from the ribs
    
    Input-Arguments:
        ribcage: 3D-matrix that contains the segmented ribcage
        colorspine: 1x3 matrix of RGB colors (each element between 0 and 255) in which the spine will be displayed
        colorribs: 1x3 matrix of RGB colors (each element between 0 and 255) in which the ribs will be displayed

    Output-Arguments:
        pcspinecenterline: pointcloud object that contains the centerline of the segmented spine
        pcspine: pointcloud object that contains the whole spine
        pcribs: pointcloud object that contains the ribs without the spine
        ribs: 3D-Matrix that contains the ribs without the spine


Function separate_ribs:
    Syntax:
        [pcindividual_ribs, pcindividual_ribs_centerlines] = seperate_ribs(ribs, pcspinecenterline, pcribs)

    Description:
        Takes the ribs (which are separated from the spine) and the centerline and returns each rib separated in a cell

    Input-Arguments:
        ribs: 3D-Matrix that contains the ribs without the spine
        pcspinecenterline: pointcloud object that contains the centerline of the segmented spine
        pcribs: pointcloud object that contains the ribs without the spine

    Output-Arguments:
        individual_ribs: cell array where each cell is one 3D-Matrix that contains only one rib
        pcindividual_ribs: cell array where each cell is a pointcloud object that contains only one individual rib



Function find_rib_pairs:
    Syntax:
        [pcrib_pairs, pcrib_pairs_centerlines] = find_rib_pairs(pcindividual_ribs, pcspinecenterline, pcribs)

    Description:
        Takes cell arrays of individual_ribs and using the position with respect to the spinecenterline finds the corresponding 
        ribs on right and left. 

    Input-Arguments:
        pcindividual_ribs: cell array where each cell is a pointcloud object that contains only one individual rib
        pcspinecenterline: pointcloud object that contains the centerline of the segmented spine
        pcribs: pointcloud object that contains the ribs without the spine

    Output-Arguments:
        pcrib_pairs: cell array with N times 2 elements where N is the amount of pairs found, rows represent corresponding ribs, each cell contains the pointcloud of one rib
        pcrib_pairs_centerlines: cell array with N x 2 elements where N is the amount of pairs found, rows represent corresponding ribs, each cell contains the centerline of a rib
        
        

Function calculate_deformity:
    Syntax:
        [pcdeformation_ribs, pcribpairs_centerlines] = calculate_deformity(pc_rib_pairs, pcribs, method, mean_threshold, std_threshold,voxeldimensions)

    Description:
        N x 2 cells containing corresponding ribs and colors the ribs depending on their deformity
    
    Input-Arguments:
        pc_rib_pairs: cell array with N times 2 elements where N is the amount of pairs found, rows represent corresponding ribs, each cell contains the pointcloud of one rib
        pcribs: pointcloud object that contains the ribs without the spine
        method: can be chosen between "distance", "derivative" and "derivative2", specifies what the values which are used for coloring the deformity. "distance" uses only the distance between the ribs after registration. "derivative" uses the absolute value first order derivative of the distances between the ribs, the more different the orientation of the ribs, the higher the derivative will be. "derivative2" uses the absolute value of the second order derivative of the distances after registration. A high value will be present if one rib has a fast change in direction (is bent) while the other doesn't.
        mean_threshold: the expected mean (eg. from data from healthy ribs) of the deformity values (distances or derivatives). Everything with a value lower than the mean will be marked as green.  
        std_threshold: the expected standard deviation of the deformatiy values. If one standard deviation is reached structures are marked yellow, with two or more standard deviations structures are marked as red.
        voxeldimensions: 1x3 array containing lengths of voxels in all three directions

    Output-Arguments:
        pcdeformation_ribs: colored pointcloud containing the ribs, colors reflect the rib deformation
        pcribpairs_centerlines: N x 2 cell (each row corresponds to one ribpair) of colored pointclouds containing the centerlines of ribs, colors reflect the rib deformation



