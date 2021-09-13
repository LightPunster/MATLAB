% Reference web site:
%http://blogs.mathworks.com/videos/2010/12/03/how-to-loop-until-a-button-is-pushed-in-matlab/?dir=autoplay

function varargout = gostop(varargin)
% GOSTOP MATLAB code for gostop.fig
%      GOSTOP, by itself, creates a new GOSTOP or raises the existing
%      singleton*.
%
%      H = GOSTOP returns the handle to a new GOSTOP or the handle to
%      the existing singleton*.
%
%      GOSTOP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOSTOP.M with the given input arguments.
%
%      GOSTOP('Property','Value',...) creates a new GOSTOP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gostop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gostop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gostop

% Last Modified by GUIDE v2.5 24-May-2015 20:26:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gostop_OpeningFcn, ...
                   'gui_OutputFcn',  @gostop_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gostop is made visible.
function gostop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gostop (see VARARGIN)

% Choose default command line output for gostop
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gostop wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gostop_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnGo.
function btnGo_Callback(hObject, eventdata, handles)
% hObject    handle to btnGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnStop, 'userdata', 0);
i = 1;
while i < 100
	% your iterative computation here
	i = i + 1;
	message = sprintf('i = %d', i);
	set(handles.text1, 'string', message);
	pause(0.1);
	drawnow
	if get(handles.btnStop, 'userdata') % stop condition
		break;
	end
end

% --- Executes on button press in btnStop.
function btnStop_Callback(hObject, eventdata, handles)
% hObject    handle to btnStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnStop,'userdata',1)
