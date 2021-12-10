<!DOCTYPE html>
<html>

<head>
    % include('./static/base/header.tpl', title = 'Dashboard')
</head>

<body id="page-top" onload="populate_chart()">
    <div id="wrapper">
        % include('./static/base/side_navbar.tpl', active_page = 'Dashboard')        
        <div class="d-flex flex-column" id="content-wrapper">
            <div id="content">
                % include('./static/base/navbar.tpl')
                <div class="container-fluid">
                    <div class="d-sm-flex justify-content-between align-items-center mb-4">
                        <h3 class="text-dark mb-0">Dashboard</h3>
                    </div>
                    <div class="row">
                        <div class="col-md-6 col-xl-3 mb-4">
                            <div class="card shadow border-start-primary py-2">
                                <div class="card-body">
                                    <div class="row align-items-center no-gutters">
                                        <div class="col me-2">
                                            <div class="text-uppercase text-primary fw-bold text-xs mb-1"><span>TODAY'S ATTENDANCE</span></div>
                                            <div class="text-dark fw-bold h5 mb-0"><span>{{unique_visitor_count}} Employees</span></div>
                                        </div>
                                        <div class="col-auto"><i class="fas fa-calendar fa-2x text-gray-300"></i></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-xl-3 mb-4">
                            <div class="card shadow border-start-success py-2">
                                <div class="card-body">
                                    <div class="row align-items-center no-gutters">
                                        <div class="col me-2">
                                            <div class="text-uppercase text-success fw-bold text-xs mb-1"><span>TOTAL REGISTERED EMPLOYEE</span></div>
                                            <div class="text-dark fw-bold h5 mb-0"><span>{{visitor_count}} Employees</span></div>
                                        </div>
                                        <div class="col-auto"><i class="fas fa-users fa-2x text-gray-300"></i></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-xl-3 mb-4">
                            <div class="card shadow border-start-info py-2">
                                <div class="card-body">
                                    <div class="row align-items-center no-gutters">
                                        <div class="col me-2">
                                            <div class="text-uppercase text-info fw-bold text-xs mb-1"><span>TOTAL REGISTERED DEVICE</span></div>
                                            <div class="row g-0 align-items-center">
                                                <div class="col">
                                                    <div class="text-dark fw-bold h5 mb-0"><span>{{terminal_count}} Terminals</span></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-auto"><i class="fas fa-tablet-alt fa-2x text-gray-300"></i></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-7 col-xl-8">
                            <div class="card shadow mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h6 class="text-primary fw-bold m-0">Employee Attendance</h6>
                                    <div class="dropdown no-arrow"><button class="btn btn-link btn-sm dropdown-toggle" aria-expanded="false" data-bs-toggle="dropdown" type="button"><i class="fas fa-ellipsis-v text-gray-400"></i></button>
                                        <div class="dropdown-menu shadow dropdown-menu-end animated--fade-in">
                                            <p class="text-center dropdown-header">dropdown header:</p><a class="dropdown-item" href="#">&nbsp;Action</a><a class="dropdown-item" href="#">&nbsp;Another action</a>
                                            <div class="dropdown-divider"></div><a class="dropdown-item" href="#">&nbsp;Something else here</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="chart-area"><canvas id="line_chart"></canvas></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-5 col-xl-4">
                            <div class="card shadow mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h6 class="text-primary fw-bold m-0">Terminal Usage</h6>
                                    <div class="dropdown no-arrow"><button class="btn btn-link btn-sm dropdown-toggle" aria-expanded="false" data-bs-toggle="dropdown" type="button"><i class="fas fa-ellipsis-v text-gray-400"></i></button>
                                        <div class="dropdown-menu shadow dropdown-menu-end animated--fade-in">
                                            <p class="text-center dropdown-header">dropdown header:</p><a class="dropdown-item" href="#">&nbsp;Action</a><a class="dropdown-item" href="#">&nbsp;Another action</a>
                                            <div class="dropdown-divider"></div><a class="dropdown-item" href="#">&nbsp;Something else here</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="chart-area"><canvas id = "bar_chart"></canvas></div>                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <footer class="bg-white sticky-footer">
                <div class="container my-auto">
                    <div class="text-center my-auto copyright"><span>Copyright © Masatrek 2021</span></div>
                </div>
            </footer>
        </div><a class="border rounded d-inline scroll-to-top" href="#page-top"><i class="fas fa-angle-up"></i></a>
    </div>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/chart.min.js"></script>
    <script src="assets/js/bs-init.js"></script>
    <script src="assets/js/theme.js"></script>
    <script>
        function populate_chart(){
            var line_graph = document.getElementById("line_chart");
            var bar_chart = document.getElementById("bar_chart");
            var myChart = new Chart(line_graph, {
                                                "type":"line",
                                                "data":{
                                                    "labels":[
                                                    % for date in dates_for_week: 
                                                    "{{date}}",
                                                    % end
                                                    ],                                                    
                                                    "datasets":[
                                                    {
                                                        "label":"Visitors",
                                                        "fill":true,
                                                        "data":[
                                                        % for unique_visitor_count in week_unique_visitor:    
                                                        "{{unique_visitor_count}}",
                                                        % end
                                                        ],
                                                        "backgroundColor":"rgba(78, 115, 223, 0.05)",
                                                        "borderColor":"rgba(78, 115, 223, 1)"
                                                    }
                                                    ]
                                                },
                                                "options":{
                                                    "maintainAspectRatio":false,
                                                    "legend":{
                                                    "display":false,
                                                    "labels":{
                                                        "fontStyle":"normal"
                                                    }
                                                    },
                                                    "title":{
                                                    "fontStyle":"normal"
                                                    },
                                                    "scales":{
                                                    "xAxes":[
                                                        {
                                                        "gridLines":{
                                                            "color":"rgb(234, 236, 244)",
                                                            "zeroLineColor":"rgb(234, 236, 244)",
                                                            "drawBorder":false,
                                                            "drawTicks":false,
                                                            "borderDash":[
                                                            "2"
                                                            ],
                                                            "zeroLineBorderDash":[
                                                            "2"
                                                            ],
                                                            "drawOnChartArea":false
                                                        },
                                                        "ticks":{
                                                            "fontColor":"#858796",
                                                            "fontStyle":"normal",
                                                            "padding":20
                                                        }
                                                        }
                                                    ],
                                                    "yAxes":[
                                                        {
                                                        "gridLines":{
                                                            "color":"rgb(234, 236, 244)",
                                                            "zeroLineColor":"rgb(234, 236, 244)",
                                                            "drawBorder":false,
                                                            "drawTicks":false,
                                                            "borderDash":[
                                                            "2"
                                                            ],
                                                            "zeroLineBorderDash":[
                                                            "2"
                                                            ]
                                                        },
                                                        "ticks":{
                                                            "fontColor":"#858796",
                                                            "fontStyle":"normal",
                                                            "padding":20
                                                        }
                                                        }
                                                    ]
                                                    }
                                                }
                                                });

            var myChart2 = new Chart(bar_chart, {
                                                "type":"doughnut",
                                                "data":{
                                                    "labels":[
                                                    % for terminal in all_terminal_usage:
                                                    "{{terminal['terminal_name']}}",
                                                    % end
                                                    ],
                                                    "datasets":[
                                                    {
                                                        "label":"",
                                                        "backgroundColor":[
                                                        "#74d2e7",
                                                        "#48a9c5",
                                                        "#0085ad",
                                                        "#8db9ca",
                                                        "#4298b5",
                                                        "#005670",
                                                        "#00205b",
                                                        "#009f4d",
                                                        "#84bd00",
                                                        "#efdf00"
                                                        ],
                                                        "borderColor":[
                                                        "#ffffff",
                                                        "#ffffff",
                                                        "#ffffff",
                                                        "#ffffff",
                                                        "#ffffff",
                                                        "#ffffff",
                                                        "#ffffff",
                                                        "#ffffff",
                                                        "#ffffff",
                                                        "#ffffff"
                                                        ],
                                                        "data":[
                                                        % for terminal in all_terminal_usage:
                                                        "{{terminal["usage"]}}",                                
                                                        % end                     
                                                        ]
                                                    }
                                                    ]
                                                },
                                                "options":{
                                                    "maintainAspectRatio":false,
                                                    "legend":{
                                                    "display":true,
                                                    "labels":{
                                                        "fontStyle":"normal"
                                                    }
                                                    },
                                                    "title":{
                                                    "fontStyle":"normal"
                                                    }
                                                }
                                                });
        }
    </script>
</body>

</html>