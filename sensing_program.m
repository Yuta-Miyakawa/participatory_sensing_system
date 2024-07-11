% ユーザーの数(N)の範囲と刻み幅の指定
N = 200;
% ラウンド数
Rounds = 100;
% 試行回数
Trials = 100;
% 予算とコストにかかる補正(コストを整数にするため)
Amount_correction = 10000;
% 有限の予算(R)
R =20 * Amount_correction;
mu1_range = [0.2, 0.4];  % μ1の範囲（コストの範囲）
mu2_range = [0.4, 0.7];  % μ2の範囲（品質の範囲）
rho_range = [0.3, 0.6];  % ρの範囲
sigma1 = 0.1;  % σ1
sigma2 = 0.1;  % σ2
risk_averse = 0.12;
loss_compensation = 2.25;


% ーーーーーー既存手法ーーーーーー
% 試行回数分の各ラウンドごとの残存ユーザ数を格納
conventional_change_of_remaining_user_per_trial = zeros(Trials, Rounds, 1);
% グラフ用の残存ユーザ数を格納
conventional_change_of_remaining_user_for_graph = zeros(Rounds, 1);
% 試行回数分の各ラウンドごとの総データ品質を格納
conventional_maxValue_ofQuality_per_trial = zeros(Trials, Rounds, 1);
% グラフ用の総データ品質を格納
conventional_maxValue_ofQuality_for_graph = zeros(Rounds, 1);
% ーーーーーーここまでーーーーーー


% ーーーーーー提案手法ーーーーーー
% 試行回数分の各ラウンドごとの残存ユーザ数を格納
proposed_change_of_remaining_user_per_trial = zeros(Trials, Rounds, 1);
% グラフ用の残存ユーザ数を格納
proposed_change_of_remaining_user_for_graph = zeros(Rounds, 1);
% 試行回数分の各ラウンドごとの総データ品質を格納
proposed_maxValue_ofQuality_per_trial = zeros(Trials, Rounds, 1);
% グラフ用の総データ品質を格納
proposed_maxValue_ofQuality_for_graph = zeros(Rounds, 1);
% ーーーーーーここまでーーーーーー


% ーーーーーー提案手法2(回数で判断)ーーーーーー
% 試行回数分の各ラウンドごとの残存ユーザ数を格納
proposed_2_change_of_remaining_user_per_trial = zeros(Trials, Rounds, 1);
% グラフ用の残存ユーザ数を格納
proposed_2_change_of_remaining_user_for_graph = zeros(Rounds, 1);
% 試行回数分の各ラウンドごとの総データ品質を格納
proposed_2_maxValue_ofQuality_per_trial = zeros(Trials, Rounds, 1);
% グラフ用の総データ品質を格納
proposed_2_maxValue_ofQuality_for_graph = zeros(Rounds, 1);
% ーーーーーーここまでーーーーーー


% ここから実際の処理

  % 試行回数分だけ回す
  for trials = 1:Trials

      % パラメータのランダムな値を生成（コストとデータ品質の生成に使用）
    mu1 = zeros(N, Rounds);
    mu2 = zeros(N, Rounds);
    rho = zeros(N, Rounds);
    sigma1_vector = ones(N, 1) * sigma1;
    sigma2_vector = ones(N, 1) * sigma2;
    
    extra_payment = 0.2; %ユーザへの支払い額補正
    
    % 一様分布 U(0.3, 0.7) からランダムな参加確率を生成
    participation_prob = rand(N, 1) * (0.7 - 0.3) + 0.3;
    % 一様分布 U(3, 1) からランダムなユーザが支払える最大金額を生成
    allowable_amount = rand(N, 1) * (3 - 1) + 1;
    % 参加行列の初期化
    participation_matrix = zeros(N, Rounds);
    % ユーザーコストの初期化
    cost = zeros(N, Rounds);
    % データ品質の初期化
    quality = zeros(N, Rounds);

    % ーーーーーー既存手法ーーーーーー
    % ユーザが支払える最大金額を格納
    conventional_user_allowable_amount = allowable_amount;
    % ユーザーの参加回数の初期化
    conventional_participation_round = zeros(N, 1);
    %フィットネスの初期化
    conventional_fitness = zeros(N, 1);
    %コスパ比率の初期化
    conventional_cost_ratio = zeros(N, Rounds);
    % 支払額の初期化   
    conventional_payment = zeros(N, 1);
    % ラウンドごとのシステムが選択したユーザの総データ品質の変化を保存するための配列
    conventional_selectedValue_ofQuality = zeros(Rounds, 1);
    % 選択されたユーザ群を格納するための配列
    conventional_selected_users = cell(Rounds, 1);
    % 現在のラウンドで残っている（システムから離脱していない）ユーザ群を格納するための変数
    conventional_remaining_user = N;
    % 現在のシステム参加におけるユーザの損得状況を保存するための配列
    conventional_user_amount = zeros(N, 1);
    % ーーーーーーここまでーーーーーー

    % ーーーーーー提案手法ーーーーーー
    % ユーザーの参加回数の初期化
    proposed_participation_round = zeros(N, 1);
    %フィットネスの初期化
    proposed_fitness = zeros(N, 1);
    %コスパ比率の初期化
    proposed_cost_ratio = zeros(N, Rounds);
    % 支払額の初期化   
    proposed_payment = zeros(N, 1);
    % ラウンドごとのシステムが選択したユーザの総データ品質の変化を保存するための配列
    proposed_selectedValue_ofQuality = zeros(Rounds, 1);
    % 選択されたユーザ群を格納するための配列
    proposed_selected_users = cell(Rounds, 1);
    % 現在のラウンドで残っている（システムから離脱していない）ユーザ群を格納するための変数
    proposed_remaining_user = N;
    % 現在のシステム参加におけるユーザの損得状況を保存するための配列
    proposed_user_amount = zeros(N, 1);
    % ユーザが支払える最大金額を格納
    proposed_user_allowable_amount = allowable_amount;
    % ーーーーーーここまでーーーーーー
    
    % ーーーーーー提案手法2(回数で判断)ーーーーーー
    % ユーザーの参加回数の初期化
    proposed_2_participation_round = zeros(N, 1);
    %フィットネスの初期化
    proposed_2_fitness = zeros(N, 1);
    %コスパ比率の初期化
    proposed_2_cost_ratio = zeros(N, Rounds);
    % 支払額の初期化   
    proposed_2_payment = zeros(N, 1);
    % ラウンドごとのシステムが選択したユーザの総データ品質の変化を保存するための配列
    proposed_2_selectedValue_ofQuality = zeros(Rounds, 1);
    % 選択されたユーザ群を格納するための配列
    proposed_2_selected_users = cell(Rounds, 1);
    % 現在のラウンドで残っている（システムから離脱していない）ユーザ群を格納するための変数
    proposed_2_remaining_user = N;
    % 現在のシステム参加におけるユーザの損得状況を保存するための配列
    proposed_2_user_amount = zeros(N, 1);
    % 現在のラウンドまでにユーザが参加して選ばれなかった回数を保存するための配列
    proposed_2_user_unselected_rounds = zeros(N, 1);
    % 現在のラウンドまでにユーザが参加した回数を保存するための配列
    proposed_2_user_paticipated_rounds = zeros(N, 1);
    % ユーザが支払える最大金額を格納
    proposed_2_user_allowable_amount = allowable_amount;
    % ーーーーーーここまでーーーーーー

    % 各ラウンドごとに参加確率に従った参加ユーザとそのときの各ユーザのコストとデータ品質を設定（全手法で同じユーザ群で比較するために先に計算しておく）
    for rounds = 1:Rounds
        for user = 1:N
            if rand() < participation_prob(user)
                % 参加する場合は1を設定
                participation_matrix(user, rounds) = 1;
                % それぞれのパラメータのランダムな値を設定
                while true
                    mu1_candidate = (mu1_range(2) - mu1_range(1)) * rand() + mu1_range(1);
                    mu2_candidate = (mu2_range(2) - mu2_range(1)) * rand() + mu2_range(1);
                    
                    % 範囲内の値かどうかを確認
                    if mu1_candidate >= mu1_range(1) && mu1_candidate <= mu1_range(2) && mu2_candidate >= mu2_range(1) && mu2_candidate <= mu2_range(2)
                        mu1(user, rounds) = mu1_candidate;
                        mu2(user, rounds) = mu2_candidate;
                        break; % 正しい範囲内の値が生成されたらループを終了
                    end
                end
                while true
                    mu = [mu1(user, rounds), mu2(user, rounds)];
                    Sigma = [sigma1_vector(user)^2, rho(user, rounds) * sigma1_vector(user) * sigma2_vector(user); rho(user, rounds) * sigma1_vector(user) * sigma2_vector(user), sigma2_vector(user)^2];
                    sample = mvnrnd(mu, Sigma);
                    cost_candidate = sample(1); % コストの候補
                    quality_candidate = sample(2); % データ品質の候補
                    
                    % 生成された値が範囲内にあるか確認
                    if cost_candidate >= mu1_range(1) && cost_candidate <= mu1_range(2) && quality_candidate >= mu2_range(1) && quality_candidate <= mu2_range(2)
                        % 範囲内の値が生成されたら保存してループを終了
                        cost(user, rounds) = cost_candidate;
                        quality(user, rounds) = quality_candidate;
                        break;
                    end
                end
                rho(user, rounds) = rand(1) * (rho_range(2) - rho_range(1)) + rho_range(1);
            end
        end
    end

    for rounds = 1:Rounds
    
        % コンソールで今どこまで処理が進んでいるか確認するため現在のラウンドを表示（デバック用）
        disp('--------------------')
        disp(['現在の試行回数： ', num2str(trials), ' / 現在のラウンド： ', num2str(rounds)])


    % ーーーーーー既存手法ーーーーーー     
        % そのラウンドでのユーザの合計のフィットネスを保存(デバック用)
        conventional_total_fitness = 0;
        % 各ラウンドにおけるアクティブユーザーの平均データ品質、フィットネス、コスパ比率を設定
        for user = 1:N
            % アクティブユーザーかどうか
            if participation_matrix(user, rounds) == 1 && conventional_user_allowable_amount(user) >= 0
                % アクティブユーザーのフィットネスの設定
                % if conventional_user_amount(user) >= 0
                    % conventional_fitness(user) = quality(user, rounds);
                % else
                    % conventional_fitness(user) = (1 + 0.1 * log(1 + 10 * conventional_participation_round(user))) * quality(user, rounds);
                % end
                conventional_fitness(user) = (1 + 0.1 * log(1 + 10 * conventional_participation_round(user))) * quality(user, rounds);
                % アクティブユーザーのコスパ比率の設定
                conventional_cost_ratio(user) = quality(user, rounds) / cost(user, rounds);
                % 参加ユーザのデータ品質を格納
                conventional_maxValue_ofQuality_per_trial(trials, rounds) = conventional_maxValue_ofQuality_per_trial(trials, rounds) + quality(user, rounds);
            else
                conventional_fitness(user) = 0;
                conventional_cost_ratio(user) = 0;
            end
            conventional_total_fitness = conventional_total_fitness + conventional_fitness(user);
        end
    
        % そのラウンドでのユーザへの合計の支払額を保存(デバック用)
        conventional_total_payment = 0;
        % 各ラウンドごとに参加したユーザー群のコスパ比率から仮の支払額を設定
        for user = 1:N
            % 基準にするコスパ比率の設定
            conventional_value_to_find = conventional_cost_ratio(user);
            if conventional_value_to_find ~= 0
                % コスパ比率全体をソート処理
                conventional_sorted_ratio = sort(conventional_cost_ratio);
                % sorted_ratioから0を削除
                conventional_nonzero_sorted_ratio = nonzeros(conventional_sorted_ratio);
                % 次に小さい値が存在するかどうかを判定
                index = find(conventional_nonzero_sorted_ratio < conventional_value_to_find, 1, 'last');
                if ~isempty(index)
                    conventional_next_smallest_raito = conventional_nonzero_sorted_ratio(index);
                    conventional_payment(user) = (quality(user, rounds) / conventional_next_smallest_raito) + extra_payment;
                else
                    conventional_payment(user) = (quality(user, rounds) / conventional_value_to_find) + extra_payment;
                end
            else
                conventional_payment(user) = 0;
            end
            conventional_total_payment = conventional_total_payment + conventional_payment(user);
        end
    
        % 支払額に基づいてユーザーを選択する処理(0/1ナップサック問題)
        % 動的計画法による解法
        % ナップサックの動的計画法テーブルの初期化
        conventional_select_user = zeros(N+1, R+1);
        conventional_user_group = cell(N+1, R+1);
        
        for user = 1:N
            conventional_payment_cost = floor(conventional_payment(user) * Amount_correction);
            for total_cost = 0:R
                if conventional_payment_cost <= total_cost
                    if conventional_fitness(user) + conventional_select_user(user, total_cost - conventional_payment_cost + 1) > conventional_select_user(user, total_cost + 1)
                        conventional_select_user(user + 1, total_cost + 1) = conventional_fitness(user) + conventional_select_user(user, total_cost - conventional_payment_cost + 1);
                        conventional_user_group{user + 1, total_cost + 1} = [conventional_user_group{user, total_cost - conventional_payment_cost + 1}, user];
                    else
                        conventional_select_user(user + 1, total_cost + 1) = conventional_select_user(user, total_cost + 1);
                        conventional_user_group{user + 1, total_cost + 1} = conventional_user_group{user, total_cost + 1};
                    end
                else
                    conventional_select_user(user + 1, total_cost + 1) = conventional_select_user(user, total_cost + 1);
                    conventional_user_group{user + 1, total_cost + 1} = conventional_user_group{user, total_cost + 1};
                end
            end
        end
        
        % 選択されたユーザを格納するセル配列を初期化
        conventional_selected_users{rounds} = conventional_user_group{N + 1, R + 1};
    
        for selected_user_index = 1:length(conventional_selected_users{rounds})
            conventional_selectedValue_ofQuality(rounds) = conventional_selectedValue_ofQuality(rounds) + quality(conventional_selected_users{rounds}(selected_user_index), rounds);
        end
    
        % 配列内の1の個数を計算
        conventional_count_ones_of_participation = 0;
        for user = 1:N
            if participation_matrix(user, rounds) == 1 && conventional_user_allowable_amount(user) >= 0
                conventional_count_ones_of_participation = conventional_count_ones_of_participation + 1;
            end
        end
        % 参加ユーザ数とシステムによって選択されたユーザ数を表示（デバック用）
        disp(conventional_count_ones_of_participation)
        disp(length(conventional_selected_users{rounds}))
    
        % ユーザの現在の損得状況の更新と離脱処理user_allowable_amount(user) >= 0
        conventional_selected_user = 1; % 選ばれたユーザ群を格納している配列median_selected_usersに用いる変数
        for user = 1:N
            if participation_matrix(user, rounds) == 1 && conventional_user_allowable_amount(user) >= 0
                if user == conventional_selected_users{rounds}(conventional_selected_user)
                    conventional_user_allowable_amount(user) = conventional_user_allowable_amount(user) + conventional_payment(user) - cost(user, rounds);
                    conventional_user_amount(user) = conventional_user_amount(user) + conventional_payment(user) - cost(user, rounds);
                    if conventional_selected_user ~= length(conventional_selected_users{rounds})
                        conventional_selected_user = conventional_selected_user + 1; % カウントアップ
                    end
                else
                    conventional_user_allowable_amount(user) = conventional_user_allowable_amount(user) - cost(user, rounds);
                    conventional_user_amount(user) = conventional_user_amount(user) - cost(user, rounds);
                end
                if conventional_user_allowable_amount(user) <= 0
                    conventional_remaining_user = conventional_remaining_user -1;
                end
            end
        end
    
        % 現在システムに残っているユーザ数を表示（デバック用）
        disp(conventional_remaining_user)
    
        % 現在のラウンドの残存ユーザ数を保存
        conventional_change_of_remaining_user_per_trial(trials, rounds) = conventional_remaining_user;
    
        % 全ユーザーのこれまでのラウンドでの合計データ品質と参加回数を管理
        for user = 1:N
            % アクティブユーザーかどうか
            if participation_matrix(user, rounds) == 1 && conventional_user_allowable_amount(user) >= 0
                conventional_participation_round(user) = conventional_participation_round(user) + 1;
            end
        end
    % ーーーーーーここまでーーーーーー
    
    
    % ーーーーーー提案手法ーーーーーー     
        % そのラウンドでのユーザの合計のフィットネスを保存(デバック用)
        proposed_total_fitness = 0;
        % 各ラウンドにおけるアクティブユーザーの平均データ品質、フィットネス、コスパ比率を設定
        for user = 1:N
            % アクティブユーザーかどうか
            if participation_matrix(user, rounds) == 1 && proposed_user_allowable_amount(user) >= 0
                % アクティブユーザーのフィットネスの設定
                if proposed_user_amount(user) >= 0
                    proposed_fitness(user) = quality(user, rounds);
                else
                    proposed_fitness(user) = (1 + 0.1 * log(1 + 300 * abs(proposed_user_amount(user)))) * quality(user, rounds);
                end
                % アクティブユーザーのコスパ比率の設定
                proposed_cost_ratio(user) = quality(user, rounds) / cost(user, rounds);
                % 参加ユーザのデータ品質を格納
                proposed_maxValue_ofQuality_per_trial(trials, rounds) = proposed_maxValue_ofQuality_per_trial(trials, rounds) + quality(user, rounds);
            else
                proposed_fitness(user) = 0;
                proposed_cost_ratio(user) = 0;
            end
            proposed_total_fitness = proposed_total_fitness + proposed_fitness(user);
        end
    
        % そのラウンドでのユーザへの合計の支払額を保存(デバック用)
        proposed_total_payment = 0;
        % 各ラウンドごとに参加したユーザー群のコスパ比率から仮の支払額を設定
        for user = 1:N
            % 基準にするコスパ比率の設定
            proposed_value_to_find = proposed_cost_ratio(user);
            if proposed_value_to_find ~= 0
                % コスパ比率全体をソート処理
                proposed_sorted_ratio = sort(proposed_cost_ratio);
                % sorted_ratioから0を削除
                proposed_nonzero_sorted_ratio = nonzeros(proposed_sorted_ratio);
                % 次に小さい値が存在するかどうかを判定
                index = find(proposed_nonzero_sorted_ratio < proposed_value_to_find, 1, 'last');
                if ~isempty(index)
                    proposed_next_smallest_raito = proposed_nonzero_sorted_ratio(index);
                    proposed_payment(user) = (quality(user, rounds) / proposed_next_smallest_raito) + extra_payment;
                else
                    proposed_payment(user) = (quality(user, rounds) / proposed_value_to_find) + extra_payment;
                end
            else
                proposed_payment(user) = 0;
            end
            proposed_total_payment = proposed_total_payment + proposed_payment(user);
        end
    
        % 支払額に基づいてユーザーを選択する処理(0/1ナップサック問題)
        % 動的計画法による解法
        % ナップサックの動的計画法テーブルの初期化
        proposed_select_user = zeros(N+1, R+1);
        proposed_user_group = cell(N+1, R+1);
        
        for user = 1:N
            proposed_payment_cost = floor(proposed_payment(user) * Amount_correction);
            for total_cost = 0:R
                if proposed_payment_cost <= total_cost
                    if proposed_fitness(user) + proposed_select_user(user, total_cost - proposed_payment_cost + 1) > proposed_select_user(user, total_cost + 1)
                        proposed_select_user(user + 1, total_cost + 1) = proposed_fitness(user) + proposed_select_user(user, total_cost - proposed_payment_cost + 1);
                        proposed_user_group{user + 1, total_cost + 1} = [proposed_user_group{user, total_cost - proposed_payment_cost + 1}, user];
                    else
                        proposed_select_user(user + 1, total_cost + 1) = proposed_select_user(user, total_cost + 1);
                        proposed_user_group{user + 1, total_cost + 1} = proposed_user_group{user, total_cost + 1};
                    end
                else
                    proposed_select_user(user + 1, total_cost + 1) = proposed_select_user(user, total_cost + 1);
                    proposed_user_group{user + 1, total_cost + 1} = proposed_user_group{user, total_cost + 1};
                end
            end
        end
        
        % 選択されたユーザを格納するセル配列を初期化
        proposed_selected_users{rounds} = proposed_user_group{N + 1, R + 1};
    
        for selected_user_index = 1:length(proposed_selected_users{rounds})
            proposed_selectedValue_ofQuality(rounds) = proposed_selectedValue_ofQuality(rounds) + quality(proposed_selected_users{rounds}(selected_user_index), rounds);
        end
    
        % 配列内の1の個数を計算
        proposed_count_ones_of_participation = 0;
        for user = 1:N
            if participation_matrix(user, rounds) == 1 && proposed_user_allowable_amount(user) >= 0
                proposed_count_ones_of_participation = proposed_count_ones_of_participation + 1;
            end
        end
        % 参加ユーザ数とシステムによって選択されたユーザ数を表示（デバック用）
        disp(proposed_count_ones_of_participation)
        disp(length(proposed_selected_users{rounds}))
    
        % ユーザの現在の損得状況の更新と離脱処理user_allowable_amount(user) >= 0
        proposed_selected_user = 1; % 選ばれたユーザ群を格納している配列median_selected_usersに用いる変数
        for user = 1:N
            if participation_matrix(user, rounds) == 1 && proposed_user_allowable_amount(user) >= 0
                if user == proposed_selected_users{rounds}(proposed_selected_user)
                    proposed_user_allowable_amount(user) = proposed_user_allowable_amount(user) + proposed_payment(user) - cost(user, rounds);
                    proposed_user_amount(user) = proposed_user_amount(user) + proposed_payment(user) - cost(user, rounds);
                    if proposed_selected_user ~= length(proposed_selected_users{rounds})
                        proposed_selected_user = proposed_selected_user + 1; % カウントアップ
                    end
                else
                    proposed_user_allowable_amount(user) = proposed_user_allowable_amount(user) - cost(user, rounds);
                    proposed_user_amount(user) = proposed_user_amount(user) - cost(user, rounds);
                end
                if proposed_user_allowable_amount(user) <= 0
                    proposed_remaining_user = proposed_remaining_user -1;
                end
            end
        end
    
        % 現在システムに残っているユーザ数を表示（デバック用）
        disp(proposed_remaining_user)
    
        % 現在のラウンドの残存ユーザ数を保存
        proposed_change_of_remaining_user_per_trial(trials, rounds) = proposed_remaining_user;
    
        % 全ユーザーのこれまでのラウンドでの合計データ品質と参加回数を管理
        for user = 1:N
            % アクティブユーザーかどうか
            if participation_matrix(user, rounds) == 1 && proposed_user_allowable_amount(user) >= 0
                proposed_participation_round(user) = proposed_participation_round(user) + 1;
            end
        end
    % ーーーーーーここまでーーーーーー
    
    
    % ーーーーーー提案手法2(回数で判断)ーーーーーー     
        % そのラウンドでのユーザの合計のフィットネスを保存(デバック用)
        proposed_2_total_fitness = 0;
        % 各ラウンドにおけるアクティブユーザーの平均データ品質、フィットネス、コスパ比率を設定
        for user = 1:N
            % アクティブユーザーかどうか
            if participation_matrix(user, rounds) == 1 && proposed_2_user_allowable_amount(user) >= 0
                % アクティブユーザーのフィットネスの設定
                proposed_2_user_paticipated_rounds(user) = proposed_2_user_paticipated_rounds(user) + 1;
                N_value = (proposed_2_user_unselected_rounds(user) / proposed_2_user_paticipated_rounds(user)) * log(proposed_2_user_unselected_rounds(user) + 1);
                proposed_2_fitness(user) = (1 + 0.2 * log(1 + 10 * N_value)) * quality(user, rounds);
                % if proposed_2_user_unselected_rounds(user) <= 0
                    % proposed_2_fitness(user) = quality(user, rounds);
                % else
                    % N_value = proposed_2_user_unselected_rounds(user) / proposed_2_user_paticipated_rounds(user) * log(proposed_2_user_unselected_rounds(user) + 1);
                    % proposed_2_fitness(user) = (1 + 0.3 * log(1 + 5 * N_value)) * quality(user, rounds);
                    % proposed_2_fitness(user) = (1 + 0.1 * log(1 + 20 * abs(proposed_2_user_unselected_rounds(user)))) * quality(user, rounds);
                % end
                % アクティブユーザーのコスパ比率の設定
                proposed_2_cost_ratio(user) = quality(user, rounds) / cost(user, rounds);
                % 参加ユーザのデータ品質を格納
                proposed_2_maxValue_ofQuality_per_trial(trials, rounds) = proposed_2_maxValue_ofQuality_per_trial(trials, rounds) + quality(user, rounds);
            else
                proposed_2_fitness(user) = 0;
                proposed_2_cost_ratio(user) = 0;
            end
            proposed_2_total_fitness = proposed_2_total_fitness + proposed_2_fitness(user);
        end
    
        % そのラウンドでのユーザへの合計の支払額を保存(デバック用)
        proposed_2_total_payment = 0;
        % 各ラウンドごとに参加したユーザー群のコスパ比率から仮の支払額を設定
        for user = 1:N
            % 基準にするコスパ比率の設定
            proposed_2_value_to_find = proposed_2_cost_ratio(user);
            if proposed_2_value_to_find ~= 0
                % コスパ比率全体をソート処理
                proposed_2_sorted_ratio = sort(proposed_2_cost_ratio);
                % sorted_ratioから0を削除
                proposed_2_nonzero_sorted_ratio = nonzeros(proposed_2_sorted_ratio);
                % 次に小さい値が存在するかどうかを判定
                index = find(proposed_2_nonzero_sorted_ratio < proposed_2_value_to_find, 1, 'last');
                if ~isempty(index)
                    proposed_2_next_smallest_raito = proposed_2_nonzero_sorted_ratio(index);
                    proposed_2_payment(user) = (quality(user, rounds) / proposed_2_next_smallest_raito) + extra_payment;
                else
                    proposed_2_payment(user) = (quality(user, rounds) / proposed_2_value_to_find) + extra_payment;
                end
            else
                proposed_2_payment(user) = 0;
            end
            proposed_2_total_payment = proposed_2_total_payment + proposed_2_payment(user);
        end
    
        % データ品質が高いユーザを保存
        high_quality_users = [];
        high_quality = sort(quality(:, rounds), 'descend');
        index = 1;
        for user = 1:N
            if high_quality(index) == quality(user, rounds)
                high_quality_users = cat(2,high_quality_users,user);
                index = index + 1;
            end
        end
        % 各ラウンドごとに参加したユーザー群のコスパ比率から仮の支払額を設定
        for user = 1:N
            % 基準にするコスパ比率の設定
            proposed_2_value_to_find = proposed_2_cost_ratio(user);
            if proposed_2_value_to_find ~= 0
                % コスパ比率全体をソート処理
                proposed_2_sorted_ratio = sort(proposed_2_cost_ratio);
                % sorted_ratioから0を削除
                proposed_2_nonzero_sorted_ratio = nonzeros(proposed_2_sorted_ratio);
                % 次に小さい値が存在するかどうかを判定
                index = find(proposed_2_nonzero_sorted_ratio < proposed_2_value_to_find, 1, 'last');
                if ~isempty(index)
                    proposed_2_next_smallest_raito = proposed_2_nonzero_sorted_ratio(index);
                    proposed_2_payment(user) = (quality(user, rounds) / proposed_2_next_smallest_raito) + extra_payment;
                else
                    proposed_2_payment(user) = (quality(user, rounds) / proposed_2_value_to_find) + extra_payment;
                end
            else
                proposed_2_payment(user) = 0;
            end
            proposed_2_total_payment = proposed_2_total_payment + proposed_2_payment(user);
        end
        
        % 支払額に基づいてユーザーを選択する処理(0/1ナップサック問題)
        % 動的計画法による解法
        % ナップサックの動的計画法テーブルの初期化
        proposed_2_select_user = zeros(N+1, R+1);
        proposed_2_user_group = cell(N+1, R+1);
        
        for user = 1:N
            proposed_2_payment_cost = floor(proposed_2_payment(user) * Amount_correction);
            for total_cost = 0:R
                if proposed_2_payment_cost <= total_cost
                    if proposed_2_fitness(user) + proposed_2_select_user(user, total_cost - proposed_2_payment_cost + 1) > proposed_2_select_user(user, total_cost + 1)
                        proposed_2_select_user(user + 1, total_cost + 1) = proposed_2_fitness(user) + proposed_2_select_user(user, total_cost - proposed_2_payment_cost + 1);
                        proposed_2_user_group{user + 1, total_cost + 1} = [proposed_2_user_group{user, total_cost - proposed_2_payment_cost + 1}, user];
                    else
                        proposed_2_select_user(user + 1, total_cost + 1) = proposed_2_select_user(user, total_cost + 1);
                        proposed_2_user_group{user + 1, total_cost + 1} = proposed_2_user_group{user, total_cost + 1};
                    end
                else
                    proposed_2_select_user(user + 1, total_cost + 1) = proposed_2_select_user(user, total_cost + 1);
                    proposed_2_user_group{user + 1, total_cost + 1} = proposed_2_user_group{user, total_cost + 1};
                end
            end
        end
        
        % 選択されたユーザを格納するセル配列を初期化
        proposed_2_selected_users{rounds} = proposed_2_user_group{N + 1, R + 1};
        %selected_users{rounds} = cat(2,selected_users{rounds},selected_users{rounds});
        %selected_users{rounds} = sort(selected_users{rounds});
    
        for selected_user_index = 1:length(proposed_2_selected_users{rounds})
            proposed_2_selectedValue_ofQuality(rounds) = proposed_2_selectedValue_ofQuality(rounds) + quality(proposed_2_selected_users{rounds}(selected_user_index), rounds);
        end
    
        % 配列内の1の個数を計算
        proposed_2_count_ones_of_participation = 0;
        for user = 1:N
            if participation_matrix(user, rounds) == 1 && proposed_2_user_allowable_amount(user) >= 0
                proposed_2_count_ones_of_participation = proposed_2_count_ones_of_participation + 1;
            end
        end
        % 参加ユーザ数とシステムによって選択されたユーザ数を表示（デバック用）
        disp(proposed_2_count_ones_of_participation)
        disp(length(proposed_2_selected_users{rounds}))
    
        % ユーザの現在の損得状況の更新と離脱処理user_allowable_amount(user) >= 0
        proposed_2_selected_user = 1; % 選ばれたユーザ群を格納している配列median_selected_usersに用いる変数
        for user = 1:N
            if participation_matrix(user, rounds) == 1 && proposed_2_user_allowable_amount(user) >= 0
                if user == proposed_2_selected_users{rounds}(proposed_2_selected_user)
                    proposed_2_user_allowable_amount(user) = proposed_2_user_allowable_amount(user) + proposed_2_payment(user) - cost(user, rounds);
                    proposed_2_user_amount(user) = proposed_2_user_amount(user) + proposed_2_payment(user) - cost(user, rounds);
                    if proposed_2_selected_user ~= length(proposed_2_selected_users{rounds})
                        proposed_2_selected_user = proposed_2_selected_user + 1; % カウントアップ
                    end
                else
                    proposed_2_user_allowable_amount(user) = proposed_2_user_allowable_amount(user) - cost(user, rounds);
                    proposed_2_user_amount(user) = proposed_2_user_amount(user) - cost(user, rounds);
                    proposed_2_user_unselected_rounds(user) = proposed_2_user_unselected_rounds(user) + 1;
                end
                if proposed_2_user_allowable_amount(user) <= 0
                    proposed_2_remaining_user = proposed_2_remaining_user -1;
                end
            end
        end
    
        % 現在システムに残っているユーザ数を表示（デバック用）
        disp(proposed_2_remaining_user)
    
        % 現在のラウンドの残存ユーザ数を保存
        proposed_2_change_of_remaining_user_per_trial(trials, rounds) = proposed_2_remaining_user;
    
        % 全ユーザーのこれまでのラウンドでの合計データ品質と参加回数を管理
        for user = 1:N
            % アクティブユーザーかどうか
            if participation_matrix(user, rounds) == 1 && proposed_2_user_allowable_amount(user) >= 0
                proposed_2_participation_round(user) = proposed_2_participation_round(user) + 1;
            end
        end
    % ーーーーーーここまでーーーーーー
    end
  end

disp('--------------------');

% 試行回数から各ラウンドの平均値を算出
for rounds = 1:Rounds
    for trials = 1:Trials
        conventional_change_of_remaining_user_for_graph(rounds) = conventional_change_of_remaining_user_for_graph(rounds) + conventional_change_of_remaining_user_per_trial(trials, rounds);
        conventional_maxValue_ofQuality_for_graph(rounds) = conventional_maxValue_ofQuality_for_graph(rounds) + conventional_maxValue_ofQuality_per_trial(trials, rounds);
        proposed_change_of_remaining_user_for_graph(rounds) = proposed_change_of_remaining_user_for_graph(rounds) + proposed_change_of_remaining_user_per_trial(trials, rounds);
        proposed_maxValue_ofQuality_for_graph(rounds) = proposed_maxValue_ofQuality_for_graph(rounds) + proposed_maxValue_ofQuality_per_trial(trials, rounds);
        proposed_2_change_of_remaining_user_for_graph(rounds) = proposed_2_change_of_remaining_user_for_graph(rounds) + proposed_2_change_of_remaining_user_per_trial(trials, rounds);
        proposed_2_maxValue_ofQuality_for_graph(rounds) = proposed_2_maxValue_ofQuality_for_graph(rounds) + proposed_2_maxValue_ofQuality_per_trial(trials, rounds);
    end
    conventional_change_of_remaining_user_for_graph(rounds) = conventional_change_of_remaining_user_for_graph(rounds) / Trials;
    conventional_maxValue_ofQuality_for_graph(rounds) = conventional_maxValue_ofQuality_for_graph(rounds) / Trials;
    proposed_change_of_remaining_user_for_graph(rounds) = proposed_change_of_remaining_user_for_graph(rounds) / Trials;
    proposed_maxValue_ofQuality_for_graph(rounds) = proposed_maxValue_ofQuality_for_graph(rounds) / Trials;
    proposed_2_change_of_remaining_user_for_graph(rounds) = proposed_2_change_of_remaining_user_for_graph(rounds) / Trials;
    proposed_2_maxValue_ofQuality_for_graph(rounds) = proposed_2_maxValue_ofQuality_for_graph(rounds) / Trials;
end

disp('総データ品質の平均値')
average_conventional_maxValue_ofQuality = 0;
average_proposed_maxValue_ofQuality = 0;
average_proposed_2_maxValue_ofQuality = 0;
for rounds = 1:Rounds
    for trials = 1:Trials
        average_conventional_maxValue_ofQuality = average_conventional_maxValue_ofQuality + conventional_maxValue_ofQuality_per_trial(trials, rounds);
        average_proposed_maxValue_ofQuality = average_proposed_maxValue_ofQuality + proposed_maxValue_ofQuality_per_trial(trials, rounds);
        average_proposed_2_maxValue_ofQuality = average_proposed_2_maxValue_ofQuality + proposed_2_maxValue_ofQuality_per_trial(trials, rounds);
    end
end
average_conventional_maxValue_ofQuality = average_conventional_maxValue_ofQuality / (Rounds * Trials);
average_proposed_maxValue_ofQuality = average_proposed_maxValue_ofQuality / (Rounds * Trials);
average_proposed_2_maxValue_ofQuality = average_proposed_2_maxValue_ofQuality / (Rounds * Trials);
disp(['既存手法の総データ品質の平均値： ', num2str(average_conventional_maxValue_ofQuality)])
disp(['提案手法1の総データ品質の平均値： ', num2str(average_proposed_maxValue_ofQuality)])
disp(['提案手法2の総データ品質の平均値： ', num2str(average_proposed_2_maxValue_ofQuality)])

% 今日の日付を取得（結果の図を保存するファイル名に使用）
currentDate = datetime('now', 'Format', 'yyyy_MM_dd');

% ラウンドごとのシステムが取得する総データ品質の変化をプロット
figure(1);
plot(1:Rounds, conventional_maxValue_ofQuality_for_graph, 'DisplayName', 'total quality in conventional method')
hold on
plot(1:Rounds, proposed_maxValue_ofQuality_for_graph, 'DisplayName', 'total quality in proposed method')
hold on
plot(1:Rounds, proposed_2_maxValue_ofQuality_for_graph, 'DisplayName', 'total quality in proposed_2 method')
xlabel('Round', 'FontSize', 14)
ylabel('total quality', 'FontSize', 14)
% 縦軸の範囲を設定
% ylim([0, 30]) % ここで縦軸の範囲を[0, 35]に設定
% title('Change in total quality over Rounds')
legend('FontSize', 14) % 凡例を表示
hold off
% グラフを保存
saveas(gcf, sprintf('%d_round_%d_users_%s_total_quality_result.fig', Rounds, N, currentDate));

% ラウンドごとの残存ユーザ数の変化をプロット
figure(2)
plot(1:Rounds, conventional_change_of_remaining_user_for_graph, 'DisplayName', 'remaining user in conventional method')
hold on
plot(1:Rounds, proposed_change_of_remaining_user_for_graph, 'DisplayName', 'remaining user in proposed method')
hold on
plot(1:Rounds, proposed_2_change_of_remaining_user_for_graph, 'DisplayName', 'remaining user in proposed_2 method')
xlabel('Round', 'FontSize', 14)
ylabel('remaining_user', 'FontSize', 14)
% 縦軸の範囲を設定
ylim([0, N]) % ここで縦軸の範囲を[0, 100]に設定
% title('Change in remaining_user over Rounds')
legend('FontSize', 14) % 凡例を表示
hold off
% グラフを保存
saveas(gcf, sprintf('%d_round_%d_users_%s_remaining_user_result.fig', Rounds, N, currentDate));
