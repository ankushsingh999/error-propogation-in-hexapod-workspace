# Error propogation in Hexapod Workspace due to kinematic parameters 
Calculated and depicted the workspace of a hexapod parallel manipulator in a specific height (a section of the workspace) and then calculated and depicted the error propagation in the workspace as a result of errors in the kinematic parameters.

Known : The diameter of the top and base platform to be 250 mm and 650 mm,respectively. Consider 𝑙𝑚𝑖𝑛 (minimum leg extension) = 604.8652 𝑚𝑚 and 𝑙𝑚𝑎𝑥 (maximum leg extension) = 1100 𝑚𝑚. Also, Consider 𝛼 (angle between  universal joint on the top platform)  = 40° and 𝛽 (angle between  universal joint on the bottom platform) = 85°.
# Steps:
Steps 1: Calculated and depicted the boundary of the constant orientation workspace of the robot when 𝑍 = 800 𝑚𝑚 and the top platform is horizontal (𝑎 = 𝑏 = 𝑐 = 0). a,b,c are the euler angles.

Steps 2: Divided/meshed the workspace calculated in step 1 into 5 𝑚𝑚 steps in both 𝑋 and 𝑌 directions. After doing this, we have a set of configurations in the form of [𝑋 𝑌 800 0 0 0]. This resulted in having “thousands of” points/configs!

# 2𝐷 boundary of the workspace in 𝑍 = 800 𝑚𝑚 plane.

![image](https://github.com/ankushsingh999/error-hexapod-WS/assets/64325043/c07f21d6-a619-46ce-950b-53377bb771f8)

Steps 3: Considered the difference between the corresponding parameters in Table 2 and Table 1 as 42 errors of the kinematic parameters (𝛿𝜌) which are needed in Equation 9.

![image](https://github.com/ankushsingh999/error-hexapod-WS/assets/64325043/403ff405-154a-43b9-9cba-25f8630e1859)

![image](https://github.com/ankushsingh999/error-hexapod-WS/assets/64325043/aca6e24b-1244-468a-8b7c-6da96f1841cf)

![image](https://github.com/ankushsingh999/error-hexapod-WS/assets/64325043/817a1b4a-8328-4daa-89e0-056b4fee87c2)


Considered 𝛿 (∆𝑙) = 0. Wrote a Matlab code to calculate the forward kinematic error model based on Equation 9 in the paper. Using the code, illustrated the position error (𝑅𝑆𝑆 − 𝑚𝑚) within the workspace when 𝑍 = 800 𝑚𝑚. In other words, calculated the position error (𝛿𝑃⃗⃗ (1: 3)) for configurations found in step 2 and then calculated 𝑅𝑆𝑆 for each position error.
# Result #
# Pose error at Z = 800 mm 

![image](https://github.com/ankushsingh999/error-hexapod-WS/assets/64325043/25005380-f8dd-4853-b64d-c0309994a476)


# Reference 

A total solution to kinematic calibration of hexapod machine tools with a minimum number of measurement configurations and superior accuracies
M.J. Nategh a, M.M. Agheli b






