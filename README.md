# Seizure prediction using nonnegative matrix factorization

This repository contains code for the project "Seizure prediction using nonnegative matrix factorization". 

In this project, a procedure for the patient-specific prediction of epileptic seizures is developed by using a combination of [nonnegative matrix factorization][1] and smooth basis functions with robust regression, applied to power spectra of [intracranial electroencephalographic (iEEG)][2] signals. Linear support vector machines (SVM) with L1 regularization are used to select and weigh the contributions from different number of not equally informative channels among patients. Due to class imbalance in data, [synthetic minority over-sampling technique (SMOTE)][3] is applied. 

The code for preprocessing was developed in [MATLAB][4], while code for prediction and visualizations was developed in [Python3][5]. The data used in this project is a part of the [EPILEPSIAE][6] dataset, which is not publicly available. For this reason, there are no specific paths or identification numbers in the code. 

[1]: https://en.wikipedia.org/wiki/Non-negative_matrix_factorization
[2]: https://en.wikipedia.org/wiki/Electrocorticography
[3]: https://imbalanced-learn.readthedocs.io/en/stable/generated/imblearn.over_sampling.SMOTE.html
[4]: https://ch.mathworks.com/de/products/matlab.html
[5]: https://www.python.org/
[6]: http://www.epilepsiae.eu/project_outputs/european_database_on_epilepsy
