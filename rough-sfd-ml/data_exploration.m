clear all
close all


% Construct the full path to the 'Results' directory
% results_dir = '/Users/red/Downloads/Spring 2024/Research/Damping Squeeze-film Flows/rough-sfd-ml/smoothsim/11-Jun-2019_Run1, Seed_1/Results';
results_dir = '/Users/red/Downloads/Spring 2024/Research/Damping Squeeze-film Flows/rough-sfd-ml/roughsims/07-Jun-2019_Run1, Seed_19/Results';
% results_dir = '/Users/red/Downloads/Spring 2024/Research/Damping Squeeze-film Flows/rough-sfd-ml/roughsims/07-Jun-2019_Run1, Seed_41/Results';


% Change the current directory to the 'Results' directory
cd(results_dir);

% Check the current directory to confirm the change
disp(['Current directory is: ' pwd]);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: Data Exploration and Preprocessing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Domain Parameters
a_data = load('a.txt'); % 'a' might represent the length of the domain in the lubrication problem.

% Simulation Parameters
t_data = load('t.txt'); % Time-stepping data for transient analysis.
hdot_data = load('hdot.txt'); % Time derivative of film thickness 'h', could be used for time-stepping.
hdotdot_data = load('hdotdot.txt'); % Second time derivative of 'h', if the analysis involves acceleration.

% Mesh Grid Data
TRIANGLES_data = load('TRIANGLES.txt'); % Connectivity information between mesh nodes, important for FEM.
X_data = load('X.txt'); % 'X' coordinate data for nodes in the mesh.
Y_data = load('Y.txt'); % 'Y' coordinate data for nodes in the mesh.
Z_data = load('Z.txt'); % 'Z' coordinate data for nodes in the mesh, if the problem is 3D.
NODES_data = load('NODES.txt'); % The discretized spatial coordinates or mesh nodes for numerical analysis.

% Fluid Properties and Initial/Boundary Conditions
h_data = load('h.txt'); % Film thickness 'h' across the domain, which is a key part of the Reynolds equation.
Pressure_data = load('Pressure.txt'); % Pressure 'p' distribution initial/boundary conditions.
Fsd_data = load('Fsd.txt'); % This could represent force data or some related parameter in the analysis.

% Figure File
% surf.fig is a figure file and can't be loaded with load. Use openfig to open the figure.
surf_fig = openfig('surf.fig'); % MATLAB figure file, potentially showing previous results or domain setup.


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the data
figure;
plot(t_data, Fsd_data);
% Example of adding labels
xlabel('Time');
ylabel('Fsd');
title('Plot of Fsd against time');
hold on; % Hold the plot for multiple plots
hold off;

% Plot the data
figure;
plot(Fsd_data);
% Example of adding labels
xlabel('No Time');
ylabel('Fsd');
title('Plot of Fsd against NO time');
hold on; % Hold the plot for multiple plots
hold off;

% Check for all that it is the same
% (Pressure_data)
% (h_data)
% (hdot_data)

% % Combine features into a single matrix (excluding NODES_data and TRIANGLES_data for now)
% h_data: Film thickness 'h' across the domain - 601 x 2
% hdot_data: Time derivative of film thickness 'h' - 1 x 601
% hdotdot_data: Second time derivative of 'h' - 1 x 601

% does this affect differen
%features = [h_data, hdot_data', hdotdot_data']; % Transpose to align dimensions

% Reshape
features = Z_data(:);

% Plotting all features on one plot
figure;
plot(features);
title('Features Plot');
xlabel('Z (51x51) 1x2601'); % Assuming the x-axis represents some index if time or other identifiers are not specified
ylabel('Feature Values');
%legend('show'); % Display legend
hold off; % Release the plot




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2: Model Selection and Training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: Prepare your data

% Scale for the time of each output
repmat_Z_data = repmat(features, 1, 601); 

% Dimension descriptions for clarity
X = repmat_Z_data'; % Should be 601x2601, where N is the number of observations
Y = Fsd_data';      % Should be 601x1 for multi-label or Nx1 for multi-class classification

% Example data preparation (assuming data is already loaded)
% X = 601x2601 matrix where each row is a reshaped 51x51 image
% Y = 601x1 vector where each element is the class label for the corresponding image
% Verify dimensions
assert(size(X, 1) == 601 && size(X, 2) == 2601, 'X must be 601x2601');
assert(length(Y) == 601, 'Y must have 601 elements');


% Split the dataset into 80% training and 20% testing
cv = cvpartition(size(X, 1), 'HoldOut', 0.2);
idxTrain = cv.training; 
idxTest = cv.test; 

X_train = X(idxTrain, :); % 481 total
Y_train = Y(idxTrain, :); % 481 total

X_test = X(idxTest, :); % 120 total
Y_test = Y(idxTest, :); % 120 total


% Step 3: Create and configure the neural network
net = feedforwardnet(10); % Example of a feedforward neural network with 10 neurons in the hidden layer

% Step 4: Train the neural network
net = train(net, X_train', Y_train');

% Step 5: Evaluate the trained model
Y_pred_train = net(X_train');
Y_pred_test = net(X_test');

% Calculate performance metrics (e.g., mean squared error)
mse_train = mean((Y_pred_train - Y_train').^2);
mse_test = mean((Y_pred_test - Y_test').^2);

% Display results
fprintf('Mean Squared Error (Training): %f\n', mse_train);
fprintf('Mean Squared Error (Testing): %f\n', mse_test);


% % %%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Step 3: Model Evaluation and Refinement
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % 
% % %%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Step 4: Deployment and Monitoring
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % 
% % 
% % 
