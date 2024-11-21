import pandas as pd
import numpy as np
from app.services.data_loader import load_logs_data, load_item_data

try:
    item_data = load_item_data()
    print("Item data loaded successfully.")
except Exception as e:
    print(f"Error loading item data: {e}")
    raise

def get_valid_services(platform):
    service_map = {
        'GS25': ['gs25_dlvy', 'gs25_pickup', 'gs25'],
        'GS더프레시': ['mart_dlvy', 'mart_pickup', 'mart'],
        'wine25': ['wine25']
    }
    return service_map.get(platform, [])

def transform_service_type(service_types):
    service_translation = {
        'gs25_dlvy': '배달',
        'gs25_pickup': '픽업',
        'mart_dlvy': '배달',
        'mart_pickup': '픽업',
        'wine25': '픽업'
    }
    transformed_services = [service_translation[service] for service in service_types if service in service_translation]
    return transformed_services

def map_platform(item):
    platforms = []
    if item['is_gs25_dlvy'] == 'Y' or item['is_gs25_pickup'] == 'Y':
        platforms.append('GS25')
    if item['is_mart_dlvy'] == 'Y' or item['is_mart_pickup'] == 'Y':
        platforms.append('GS더프레시')
    if item['is_wine25'] == 'Y':
        platforms.append('wine25')
    return platforms

# item_data에 'platforms' 열 추가
item_data['platforms'] = item_data.apply(map_platform, axis=1)

def prepare_data(data):
    try:
        current_time = pd.Timestamp.now()
        data['date'] = pd.to_datetime(data['date'], errors='coerce')
        data['event_time'] = pd.to_datetime(data['event_time'], format='%H:%M:%S.%f', errors='coerce')

        print("Date conversion check:")
        print(data[['date', 'event_time']].head())

        data['time_weight'] = np.where((current_time - data['date']).dt.days <= 7, 2,
                                       np.where((current_time - data['date']).dt.days <= 30, 1.5, 1))

        print("Unique values in 'inter':", data['inter'].unique())

        weights = {'view': 1, 'cart': 3, 'order': 5}
        data['weighted_score'] = data['inter'].map(weights) * data['time_weight']

        if data['weighted_score'].isna().any():
            print("Warning: NaN found in 'weighted_score' column.")
            print(data[data['weighted_score'].isna()][['inter', 'weighted_score']])

        print("Data prepared successfully.")
        return data
    except Exception as e:
        print(f"Error in prepare_data: {e}")
        raise

def recommend_new_user(new_user_category, platform, logs):
    # logs 데이터에서 특정 플랫폼의 서비스 필터링
    valid_services = get_valid_services(platform)
    logs = logs[logs['service'].isin(valid_services)]
    print(f"Filtered logs for platform '{platform}':")
    print(logs.head())

    # logs와 item_data 병합
    data = pd.merge(logs, item_data, left_on='item_id', right_on='id', how='inner')

    # item_data에서 플랫폼 매칭 확인
    data = data[data['platforms'].apply(lambda x: platform in x)]

    # 플랫폼과 일치하지 않는 아이템 제거 (디버깅용 로그 추가)
    print(f"Data count before platform filtering: {len(data)}")
    data = data[data['platforms'].apply(lambda x: platform in x)]
    print(f"Data count after platform filtering: {len(data)}")

    # 데이터 준비
    data = prepare_data(data)
    data = data[data['bd_item_lcls_nm'].isin(new_user_category)]

    if data.empty:
        # 데이터가 없는 경우: 사용자가 선택한 카테고리의 상품을 랜덤으로 선택
        print("No data available for selected categories. Selecting random items.")
        random_items = item_data[item_data['bd_item_lcls_nm'].isin(new_user_category) &
                                 item_data['platforms'].apply(lambda x: platform in x)].sample(n=20, replace=True)
        recommendations = [format_recommendation_for_new_user(item['id'], platform, item_data) for _, item in random_items.iterrows()]
        return {"items": recommendations}

    category_groups = {
        cat: data[data['bd_item_lcls_nm'] == cat].groupby('item_id').size().sort_values(
            ascending=False).head(20)
        for cat in new_user_category
    }

    recommendations = []
    seen_items = set()

    for i in range(20):
        for cat in new_user_category:
            category_items = category_groups.get(cat, [])
            if i < len(category_items.index):
                item_id = category_items.index[i]
                if item_id not in seen_items:
                    recommendations.append(format_recommendation_for_new_user(item_id, platform, item_data))
                    seen_items.add(item_id)
                    if len(recommendations) >= 20:
                        break
        if len(recommendations) >= 20:
            break

    print(f"Total number of recommended items: {len(recommendations)}")
    for item in recommendations:
        print(item)

    return {"items": recommendations[:20]}


def format_recommendation_for_new_user(item_id, platform, item_data):
    item_info = item_data[item_data['id'] == item_id]

    if item_info.empty:
        print(f"Item ID {item_id} not found in item data.")
        return None

    item_info = item_info.iloc[0]
    print(f"Item info for {item_id}: {item_info.to_dict()}")  # 디버깅용: 아이템 정보 출력

    service_map = {
        'is_gs25_dlvy': '배달',
        'is_gs25_pickup': '픽업',
        'is_mart_dlvy': '배달',
        'is_mart_pickup': '픽업',
        'is_wine25': '픽업'
    }

    platform_services = {
        'GS25': ['is_gs25_dlvy', 'is_gs25_pickup'],
        'GS더프레시': ['is_mart_dlvy', 'is_mart_pickup'],
        'wine25': ['is_wine25']
    }

    valid_service_fields = platform_services.get(platform, [])
    transformed_service_type = [
        service_map[field] for field in valid_service_fields if item_info.get(field) == 'Y'
    ]

    if not transformed_service_type:
        print(f"No valid service type found for item ID {item_id} based on platform '{platform}'. "
              f"Checked fields: {valid_service_fields}, Values: {[item_info.get(field) for field in valid_service_fields]}")

    recommendation = {
        "itemId": str(item_info['id']),
        "platform": platform,
        "serviceType": transformed_service_type,
        "price": float(item_info.get('price', 0.0)),
        "s3url": item_info.get('s3url', None),
        "itemName": item_info.get('bd_item_nm', 'No Name')
    }

    return recommendation


def collaborative_filtering_recommendations(user_id, user_data, data, top_n=10):
    try:
        user_item_matrix = data.pivot_table(index='user_id', columns='item_id', values='weighted_score', aggfunc='sum')
        user_item_matrix.fillna(0, inplace=True)

        user_vector = user_item_matrix.loc[user_id] if user_id in user_item_matrix.index else None
        if user_vector is None:
            print("User ID not found in user-item matrix. Skipping collaborative filtering.")
            return []

        from sklearn.metrics.pairwise import cosine_similarity
        user_similarity = cosine_similarity([user_vector], user_item_matrix)

        similarity_df = pd.DataFrame(user_similarity[0], index=user_item_matrix.index, columns=['similarity'])
        similarity_df = similarity_df.sort_values(by='similarity', ascending=False).iloc[1:]  # 자기 자신 제외

        similar_users = similarity_df.head(top_n).index

        similar_users_data = data[data['user_id'].isin(similar_users)]
        similar_items_scores = similar_users_data.groupby('item_id')['weighted_score'].sum().sort_values(ascending=False)

        already_purchased = user_data['item_id'].unique()
        recommendations = similar_items_scores[~similar_items_scores.index.isin(already_purchased)].head(top_n)

        recommendation_list = [
            format_recommendation(item_id, "Collaborative Filtering", user_data)
            for item_id in recommendations.index
        ]

        return recommendation_list
    except Exception as e:
        print(f"Error in collaborative_filtering_recommendations: {e}")
        raise

def hybrid_recommendation(user_id, platform, logs):
    try:
        print(f"Starting recommendation for user_id: {user_id}")

        if 'event_time' not in logs.columns:
            print("Error: 'event_time' field is missing from logs.")
            raise ValueError("'event_time' field is missing from logs data.")
        else:
            print("Verified 'event_time' field exists in logs.")

        data = pd.merge(logs, item_data, left_on='item_id', right_on='id', how='left')

        data = prepare_data(data)

        valid_services = get_valid_services(platform)
        print(f"Valid services for platform '{platform}': {valid_services}")

        user_data = data[(data['user_id'] == user_id) & (data['service'].isin(valid_services))]
        print(f"Filtered user data count: {len(user_data)}")
        if not user_data.empty:
            print("Sample user data after filtering:\n", user_data.head())
        else:
            print("Filtered user data is empty. Debugging details:")
            print("User data before filtering:\n", data[data['user_id'] == user_id].head())
            print(f"Services found for user_id={user_id}: {data[data['user_id'] == user_id]['service'].unique()}")

        if user_data.empty:
            print("No data found for the given user after filtering.")
            return {"message": "No valid user data found for the given user."}

        subcategory_scores = user_data.groupby('bd_item_scls_cd')['weighted_score'].sum().sort_values(ascending=False).head(3)
        selected_subcategories = subcategory_scores.index.tolist()
        print(f"Selected subcategories: {selected_subcategories}")

        subcategory_recommendations = {}

        purchase_counts = user_data[user_data['inter'] == 'order'].groupby('item_id').size()
        frequently_purchased_items = purchase_counts[purchase_counts >= 2].index.tolist()
        print(f"Frequently purchased items: {frequently_purchased_items}")

        for subcategory in selected_subcategories:
            subcategory_data = data[(data['bd_item_scls_cd'] == subcategory) & (data['service'].isin(valid_services))]
            popular_items = subcategory_data.groupby('item_id').size().sort_values(ascending=False).head(20).index.tolist()
            print(f"Popular items in subcategory {subcategory}: {popular_items}")

            recommendations = [format_recommendation(item_id, platform, user_data) for item_id in popular_items if item_id not in frequently_purchased_items]

            purchased_recommendations = [format_recommendation(item_id, platform, user_data) for item_id in frequently_purchased_items if item_id in popular_items]
            recommendations = purchased_recommendations + recommendations

            seen = set()
            unique_recommendations = []
            for item in recommendations:
                if item['itemId'] not in seen:
                    seen.add(item['itemId'])
                    unique_recommendations.append(item)

            subcategory_recommendations[subcategory] = unique_recommendations[:30]
            print(f"Recommendations for subcategory {subcategory}: {unique_recommendations[:5]}...")

        collaborative_recommendations = collaborative_filtering_recommendations(user_id, user_data, data)
        print(f"Collaborative filtering recommendations: {collaborative_recommendations[:5]}...")

        final_recommendations = []
        for i in range(30):
            for subcategory in selected_subcategories:
                if i < len(subcategory_recommendations[subcategory]):
                    final_recommendations.append(subcategory_recommendations[subcategory][i])
                if len(final_recommendations) >= 30:
                    break
            if len(final_recommendations) >= 30:
                break

        for rec in collaborative_recommendations:
            if len(final_recommendations) >= 30:
                break
            if rec['itemId'] not in [r['itemId'] for r in final_recommendations]:
                final_recommendations.append(rec)

        if not final_recommendations:
            print("No recommendations found after processing.")
            raise ValueError("No recommendations available after processing.")

        print("Final recommendations prepared.")
        return {"items": final_recommendations}
    except Exception as e:
        print(f"Error in hybrid_recommendation: {e}")
        raise

def format_recommendation(item_id, platform, user_data):
    try:
        item_info = item_data[item_data['id'] == item_id].iloc[0] if not item_data[
            item_data['id'] == item_id].empty else None

        if item_info is None:
            print(f"Item ID {item_id} not found in item data.")
            return None

        service_map = {
            'is_gs25_dlvy': '배달',
            'is_gs25_pickup': '픽업',
            'is_mart_dlvy': '배달',
            'is_mart_pickup': '픽업',
            'is_wine25': '픽업'
        }

        platform_services = {
            'GS25': ['is_gs25_dlvy', 'is_gs25_pickup'],
            'GS더프레시': ['is_mart_dlvy', 'is_mart_pickup'],
            'wine25': ['is_wine25']
        }

        valid_service_fields = platform_services.get(platform, [])
        transformed_service_type = [
            service_map[field] for field in valid_service_fields if item_info.get(field) == 'Y'
        ]

        if not transformed_service_type:
            print(f"No valid service type found for item ID {item_id} based on platform '{platform}'.")

        formatted_item = {
            "itemId": item_id,
            "itemName": item_info['bd_item_nm'] if item_info is not None else '알 수 없음',
            "platform": platform,
            "serviceType": transformed_service_type,
            "price": item_info['price'] if item_info is not None else 0,
            "s3url": item_info['s3url'] if item_info is not None else None,
            "recommendationDate": pd.Timestamp.now().isoformat(),
            "purchaseDates": list(user_data[user_data['item_id'] == item_id]['date'].dropna().unique())
        }

        print(f"Formatted item: {formatted_item}")
        return formatted_item
    except Exception as e:
        print(f"Error formatting recommendation for item {item_id}: {e}")
        raise

