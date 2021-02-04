// ignore_for_file: prefer_single_quotes

class TransactionJson {
  static const listTransaction = <Map<String, dynamic>>[
    {
      'id': 'd3c5d7b5-1f1a-47b1-82a2-a0ec66b70b7f',
      'amount': 41900,
      'description': '',
      'type': 'EXPENSE',
      'category': {
        'id': '1f8820da-f1b2-48c4-8ffb-ac49abbb7067',
        'name': 'Food',
        'iconURL':
            'https://res.cloudinary.com/dwxrp75d0/image/upload/v1602479481/sickfits/gcdxgwj2ddj0fmtxuujm.png',
        'credit': ''
      },
      'createdAt': 1610363159,
      'updatedAt': 1610363159,
      'userId': '284c5ca4-9d46-4259-a98d-8331f06b38d2'
    },
    {
      'id': '2e31bf2d-f127-414b-a537-357cc8002757',
      'amount': 50000,
      'description': '',
      'type': 'EXPENSE',
      'category': {
        'id': '1f8820da-f1b2-48c4-8ffb-ac49abbb7067',
        'name': 'Food',
        'iconURL':
            'https://res.cloudinary.com/dwxrp75d0/image/upload/v1602479481/sickfits/gcdxgwj2ddj0fmtxuujm.png',
        'credit': ''
      },
      'createdAt': 1610363090,
      'updatedAt': 1610363149,
      'userId': '284c5ca4-9d46-4259-a98d-8331f06b38d2'
    }
  ];

  static const balanceReport = {
    "income": [
      {"date": "2021-01-31T00:00:00Z", "total": 0},
      {"date": "2021-02-01T00:00:00Z", "total": 200000},
      {"date": "2021-02-02T00:00:00Z", "total": 0},
      {"date": "2021-02-03T00:00:00Z", "total": 0},
      {"date": "2021-02-04T00:00:00Z", "total": 0},
      {"date": "2021-02-05T00:00:00Z", "total": 0},
      {"date": "2021-02-06T00:00:00Z", "total": 0}
    ],
    "expense": [
      {"date": "2021-01-31T00:00:00Z", "total": 0},
      {"date": "2021-02-01T00:00:00Z", "total": 120000},
      {"date": "2021-02-02T00:00:00Z", "total": 30000},
      {"date": "2021-02-03T00:00:00Z", "total": 0},
      {"date": "2021-02-04T00:00:00Z", "total": 0},
      {"date": "2021-02-05T00:00:00Z", "total": 0},
      {"date": "2021-02-06T00:00:00Z", "total": 0}
    ]
  };
}
