function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));


h0=sigmoid([ones(m, 1) X]*Theta1'); % is a 5000x25 matrix

h1=sigmoid([ones(size(h0,1), 1) h0]*Theta2'); % is a 5000x10 matrix
Y = zeros(size(h1));
% X = [ones(m, 1) X]; % adding bias unit to X
%% Removing the bias unit from Theta1 & Theta2
T1=Theta1(:,2:size(Theta1,2));
T2=Theta2(:,2:size(Theta2,2));
%% running for loop for K times(K = no. of output units)
for i=1:num_labels,
%% c is a column vector of same length of y,
%% which is used to match with y, to give binary column matrix of size 5000x1
    c=i*ones(size(y));
%% Cost function, J || "y==c" gives logical vector of length of output unit,y;
    J = J -(1/m)*[(y==c)'*log(h1(:,i))+(1-(y==c))'*log(1-(h1(:,i)))];
end;
%% adding the regularization to cost function
%% outside for loop as the regularization part is a Real Number so must not increment J after every iteration of i
J = J + (lambda/(2*m))*(sum(sum(T1.^2))+sum(sum(T2.^2)));
% -------------------------------------------------------------
for i=1:num_labels,
    Y(:,i)=(y==i);
end;
for t=1:m,
%% for input layer(l=1)
%% adding bias unit
    a1=[1 X(t,:)];
%% for hidden layer(l=2)
    z2=Theta1*a1';
    a2=sigmoid(z2);
%% adding bias unit
    a2=[1;a2];
    z3=Theta2*a2;
    a3=sigmoid(z3);
%% error at the output layer
    del3=a3-Y(t,:)';
%% error at the hidden layer
    del2=(Theta2'*del3).*[1;sigmoidGradient(z2)];
    del2=del2(2:end,:);
%% Theta gradients
    Theta1_grad = Theta1_grad + del2*a1;
    Theta2_grad = Theta2_grad + del3*a2';
end;
% =========================================================================
%% Regularized
Theta1_grad = (1/m) * Theta1_grad + ....
                      (lambda/m) * [zeros(size(Theta1, 1), 1) Theta1(:,2:end)];
Theta2_grad = (1/m) * Theta2_grad + ....
                      (lambda/m) * [zeros(size(Theta2, 1), 1) Theta2(:,2:end)];
% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
