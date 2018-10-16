from pandas.io.json import json_normalize
import pandas as pd
import numpy as np
import json

data_in = {

                'index_start': 1539207900,

                'index_end': 1539208020,

                'index_step': 60,

    'columns': ['accountapiprod_accountaccountnumberdetails_overall_errorspermin',

        'accountapiprod_accountaccountnumberdetails_overall_responsetimems95th',

        'xpcprodcodebig2netv1gatewaycpe_errorspermin',

        'xpcprodcodebig2netv1gatewaycpe_responsetimemsavg'

    ],

                'series': [{

                                                'name': 'tech360',

                                                'tags': {

                                                                'feature': 'accountapiprod_accountaccountnumberdetails_overall_errorspermin',

                                                                'type': 'appd-bt'

                                                },

                                                'columns': ['time', 'value'],

                                                'values': [[1539207900, 50],

                                                                [1539207960, 0],

                [1539208020, 10]]

                                }, {

                                                'name': 'tech360',

                                                'tags': {

                                                                'feature': 'accountapiprod_accountaccountnumberdetails_overall_responsetimems95th',

                                                                'type': 'appd-bt'

                                                },

                                                'columns': ['time', 'value'],

                                                'values': [[1539207900, 1000],

                                                                [1539207960, 0],

                [1539208020, 10]]

                                }, {

                                                'name': 'tech360',

                                                'tags': {

                                                                'feature': 'xpcprodcodebig2netv1gatewaycpe_errorspermin',

                                                                'type': 'appd-be'

                                                },

                                                'columns': ['time', 'value'],

                                                'values': [[1539207900, 20],

                                                                [1539207960, 0],

                [1539208020, 10]]

                                }, {

                                                'name': 'tech360',

                                                'tags': {

                                                                'feature': 'xpcprodcodebig2netv1gatewaycpe_responsetimemsavg',

                                                                'type': 'appd-be'

                                                },

                                                'columns': ['time', 'value'],

                                                'values': [[1539207900, 500],

                                                                [1539207960, 0],

                [1539208020, 10]]

                                }

                ]

}
# print(type(data_in))
df = pd.DataFrame.from_dict(data_in)
# print('df_str')
# print('-------------------------------')
# print(df.shape[0])
# print(len(range(data_in['index_start'],data_in['index_end']+1,data_in['index_step'])))
# print('-------------------------------')
frame = list()
rows = df.shape[0]
cols = len(range(data_in['index_start'],data_in['index_end']+1,data_in['index_step']))
for j in range(0, cols):
    for i in range(0, rows):
        frame.append(json_normalize(df['series'])['values'].values.flatten()[i][j][1])
shaped = np.reshape(frame,(cols,rows))
# print(np.reshape(frame,(3,4)))
df2 = pd.DataFrame(shaped, columns = data_in['columns'], index = (range(data_in['index_start'],data_in['index_end']+1,data_in['index_step'])))
print('data_inter')
print('-------------------------------')
print(df2)
print('-------------------------------')
print('data_out')
print('-------------------------------')
print(df2.to_json(orient='split'))

# data_out = {
#
#     'columns': ['accountapiprod_accountaccountnumberdetails_overall_errorspermin',
#                 'accountapiprod_accountaccountnumberdetails_overall_responsetimems95th',
#                 'xpcprodcodebig2netv1gatewaycpe_errorspermin', 'xpcprodcodebig2netv1gatewaycpe_responsetimemsavg'],
#
#     'index': [1539207900, 1539207960, 1539208020],
#
#     'data': [[50, 1000, 20, 500], [0, 0, 0, 0], [10, 10, 10, 10]]
#
# }
