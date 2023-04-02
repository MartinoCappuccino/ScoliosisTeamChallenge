The Ribbles software was developed to evaluate the rib deformity in scoliotic patients. 
From CT scans corresponding ribs from the right and left are compared. The output is a 
visualization of the ribcage where parts of ribs that are not or only slightly deformed 
are colored green. The stronger the deformation the more red a rib will be colored.


The Ribbles Software consists of five main functions and a Graphical User Interface (GUI):

GUI:
    To use the GUI all functions have to be added to the Matlab path. To start the GUI type "Ribbles" 
    in the Matlab command line.
    A window will appear where you can load peoperative and postoperative .nii files from the CT scans.

    Once the scan is loaded the button "Start Algorithm" can be pressed. A new window will appear.
    The user has to draw a box around the region of the spine with big margins, then right-click on the 
    image and select "crop image". 

    After that the calculations runs for about one minute.

    Once the calculations are finished the ribcage with colored ribs are displayed. To the left of the 
    image checkmarks can be set to visualize centerlines of ribs and spine, the segmentations of ribs 
    and spine and which ribs are recognized as corresponding. (Note: some whole structures will always 
    overlap the centerlines).



Function get_ribcage:
    Syntax:
        [pcribcage, ribcage]=get_ribcage(file_name, closing_kernel, opening_kernel, lower_threshold, upper_threshold, colorribcage)

    Description:
        Takes the nifti file of CT scan and returns the segmented ribcage as a pointcloud object and a 3D-Matrix

    Input-Arguments:
        file_name: string, path to nifti of CT scan
        closing_kernel: scalar, size of structural element for morphological closing during segmentation
        opening_kernel: scalar, size of structural element for morphological opening during segmentation
        lower_threshold: scalar, lower threshold for Hounsfield units for segmentation
        upper_threshold: scalar, upper threshold for Hounsfield units for segmentation (to remove metal objects on postop)
        colorribcage: 1x3 matrix of RGB colors (each element between 0 and 255) in which the ribcage will be displayed

    Output-Arguments:
        pcribcage: pointcloud object that contains the segmented ribcage
        ribcage: 3D-Matrix that contains the segmented ribcage



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
        [pcdeformation_ribs, pcribpairs_centerlines] = calculate_deformity(pc_rib_pairs, pcribs)

    Description:
        N x 2 cells containing corresponding ribs and colors the ribs depending on their deformity
    
    Input-Arguments:
        pcrib_pairs: cell array with N times 2 elements where N is the amount of pairs found, rows represent corresponding ribs, each cell contains the pointcloud of one rib
        pcribs: pointcloud object that contains the ribs without the spine

    Outpur-Arguments:
        pcdeformation_ribs: colored pointcloud containing the ribs, colors reflect the rib deformation
        pcindividual_ribs_centerlines:  colored pointcloud containing the centerlines of ribs, colors reflect the rib deformation



