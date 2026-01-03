from flask import render_template, request, jsonify, current_app
import json
import os
from . import portfolio_bp
from .logic import process_zerodha_file, process_smallcase_file, get_portfolio_summary, get_pnl_summary

@portfolio_bp.route('/portfolio')
def portfolio_dashboard():
    """Render the main Portfolio & P&L page."""
    portfolio_data = get_portfolio_summary()
    pnl_data = get_pnl_summary()
    return render_template('portfolio.html', portfolio=portfolio_data, pnl=pnl_data)

import config

@portfolio_bp.route('/api/portfolio/summary')
def api_portfolio_summary():
    """Return Portfolio Summary as JSON for Dashboard."""
    account_id = request.args.get('account_id')
    try:
        portfolio_rows = get_portfolio_summary(account_id)
        
        # Calculate Aggregates
        total_invested = sum(row['invested_value'] for row in portfolio_rows)
        current_value = sum(row['current_value'] for row in portfolio_rows)
        if current_value == 0:
             current_value = total_invested # Fallback if no live data yet
             
        pnl_absolute = current_value - total_invested
        pnl_percent = (pnl_absolute / total_invested * 100) if total_invested > 0 else 0
        
        return jsonify({
            "summary": {
                "total_invested": total_invested,
                "current_value": current_value,
                "pnl_absolute": pnl_absolute,
                "pnl_percent": round(pnl_percent, 2)
            },
            "holdings": portfolio_rows # RealDictCursor returns list of dicts
        })
    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

@portfolio_bp.route('/api/config/accounts')
def api_config_accounts():
    """Return list of accounts for UI selector."""
    accounts = []
    show_all = request.args.get('all', 'false').lower() == 'true'
    try:
        if show_all:
            source = config.get_all_accounts()
        else:
            source = config.get_operational_accounts()
            
        for user, acc_type, acc_id, details in source:
            accounts.append({
                "id": acc_id,
                "label": f"{user.upper()} - {acc_type.replace('_', ' ').title()}",
                "user": user,
                "type": acc_type,
                "broker": details.get("broker")
            })
        return jsonify(accounts)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@portfolio_bp.route('/settings/mappings')
def settings_page():
    """Render the Settings Page (Flask)."""
    return render_template('settings_mappings.html')

@portfolio_bp.route('/api/upload/zerodha', methods=['POST'])
def upload_zerodha():
    """Handle Zerodha Tradebook upload."""
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    
    file = request.files['file']
    account_id = request.form.get('account_id')
    source = request.form.get('source', 'ZERODHA')
    
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
        
    if not account_id:
        return jsonify({'error': 'Account ID is required'}), 400
        
    try:
        success, message = process_zerodha_file(file, account_id, source)
        if success:
            return jsonify({'message': message}), 200
        else:
            return jsonify({'error': message}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@portfolio_bp.route('/api/upload/smallcase', methods=['POST'])
def upload_smallcase():
    """Handle Smallcase Orders upload."""
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
        
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
        
    try:
        success, message = process_smallcase_file(file)
        if success:
            return jsonify({'message': message}), 200
        else:
            return jsonify({'error': message}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@portfolio_bp.route('/api/config/preview_csv', methods=['POST'])
def api_preview_csv():
    """Preview CSV content with parsing options."""
    from .logic import preview_csv_file
    
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
        
    file = request.files['file']
    skip_rows = int(request.form.get('skip_rows', 0))
    skip_cols = int(request.form.get('skip_cols', 0)) # NEW
    
    result = preview_csv_file(file, skip_rows, skip_cols)
    if 'error' in result:
        return jsonify(result), 500
    return jsonify(result)

@portfolio_bp.route('/api/config/broker_config', methods=['GET', 'POST'])
def api_broker_config():
    """Manage Broker Configs."""
    from .logic import get_broker_config, upsert_broker_config
    
    if request.method == 'GET':
        provider = request.args.get('provider')
        if not provider: return jsonify({'error': 'Provider required'}), 400
        return jsonify(get_broker_config(provider))
        
    if request.method == 'POST':
        data = request.json
        provider = data.get('provider')
        skip_rows = int(data.get('skip_rows', 0))
        skip_cols = int(data.get('skip_cols', 0)) # NEW
        
        if upsert_broker_config(provider, skip_rows, 0, skip_cols):
            return jsonify({'message': 'Configuration saved.'})
        return jsonify({'error': 'Database error'}), 500

@portfolio_bp.route('/api/config/mappings', methods=['GET', 'POST'])
def api_config_mappings():
    """Manage CSV Mappings."""
    from .logic import get_all_csv_mappings, upsert_csv_mapping
    
    if request.method == 'GET':
        provider = request.args.get('provider')
        return jsonify(get_all_csv_mappings(provider))
    
    if request.method == 'POST':
        data = request.json
        provider = data.get('provider')
        csv_col = data.get('csv_column')
        db_col = data.get('db_column')
        
        if not all([provider, csv_col, db_col]):
            return jsonify({'error': 'Missing required fields'}), 400
            
        success, msg = upsert_csv_mapping(provider, csv_col, db_col)
        if success:
            return jsonify({'message': msg})
        else:
            return jsonify({'error': msg}), 500

@portfolio_bp.route('/api/config/brokers')
def get_available_brokers():
    """Return list of brokers from portfolio_rules.json api_mapping."""
    try:
        rules_path = os.path.join(current_app.root_path, 'portfolio_rules.json')
        if not os.path.exists(rules_path):
             return jsonify([])
             
        with open(rules_path, 'r') as f:
            data = json.load(f)
            brokers = list(data.get('api_mapping', {}).keys())
            return jsonify(brokers)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
