const routers = [
    <#start foreach_table#>
    { path: '<#table_name#>', name: '<#table_name_formated#>', component: () => import('@/views/<#table_name#>/<#table_name#>-index') },
    { path: '<#table_name#>/create', name: 'Create <#table_name_formated#>', component: () => import('@/views/<#table_name#>/<#table_name#>-create') },
    { path: '<#table_name#>/edit/:id', name: 'Edit <#table_name_formated#>', component: () => import('@/views/<#table_name#>/<#table_name#>-edit') },
    <#end foreach_table#>
];

export default routers