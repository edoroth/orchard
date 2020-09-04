bag_filter_sum :: CPSFuzz (Bag Number) -> CPSFuzz Number
bag_filter_sum db =
  bfilter gt_10 db $
    \gt_10_db -> bfilter lt_5 db $
      \lt_5_db -> bsum 20 gt_10_db $
        \gt_10_sum -> bsum 5 lt_5_db $
          \lt_10_sum -> gt_10_sum + lt_10_sum
  where
    gt_10 :: Expr Number -> Expr Bool
    gt_10 v = v %> 10
    lt_5 :: Expr Number -> Expr Bool
    lt_5 v = v %< 5

bag_filter_sum_noise :: CPSFuzz (Bag Number) -> CPSFuzzDistr Number
bag_filter_sum_noise db =
  share (bag_filter_sum db) $
    \s -> do
      s1' <- lap 1.0 s
      s2' <- lap 2.0 s
      return (s1' + s2')

bag_map_filter_sum :: CPSFuzz (Bag Number) -> CPSFuzz Number
bag_map_filter_sum db =
  bmap (* 2) db bag_filter_sum
