function [m_s_n,m_p_n,varargout] = SimilarStageDesign(m_L,m_0,epsilon,n,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Ex 1: [ms, mp] = SimilarStageDesign(1000, 15000, 1/7, 2)
%   Ex 2: [ms, mp, dv] = SimilarStageDesign(1000, 15000, 1/7, 2, 'Isp', 311)
%   Ex 3: [ms, mp, dv] = SimilarStageDesign(1000, 15000, 1/7, 2, 'c', 3048)

    lambda = ((m_0/m_L)^(1/n) - 1)^-1;
    
    m_L_n = zeros(1,n);
    m_s_n = zeros(1,n);
    m_0_n = zeros(1,n);
    m_p_n = zeros(1,n);
    
    m_L_n(end) = m_L;
    for i=n:-1:1
        m_0_n(i) = (1/lambda + 1)*m_L_n(i);
        m_s_n(i) = epsilon*(m_0_n(i) - m_L_n(i));
        m_p_n(i) = m_0_n(i) - m_s_n(i) - m_L_n(i);
        if i>1
            m_L_n(i-1) = m_0_n(i);
        end
    end
    
    %Delta v calculation
    if nargin>4
        Z = (1 + lambda)/(lambda + epsilon);
        switch varargin{1}
            case 'c'
                varargout{1} = varargin{2}*log(Z^n);
            case 'Isp'
                varargout{1} = 9.807*varargin{2}*log(Z^n);
        end
    end
end

