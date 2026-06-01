-- ============================================================
-- Migration 025: Atomic admin delete for technicians
-- ============================================================

CREATE OR REPLACE FUNCTION public.admin_delete_technician(p_technician_id BIGINT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF COALESCE(auth.jwt() -> 'user_metadata' ->> 'role', '') <> 'admin' THEN
    RAISE EXCEPTION 'not authorized';
  END IF;

  DELETE FROM public.profile_verification_submissions
  WHERE auth_id = (
    SELECT t.auth_id
    FROM public.technician t
    WHERE t.technician_id = p_technician_id
  );

  DELETE FROM public.request_offers
  WHERE technician_id = p_technician_id;

  UPDATE public.request
  SET technician_id = NULL
  WHERE technician_id = p_technician_id;

  UPDATE public.complaint
  SET technician_id = NULL
  WHERE technician_id = p_technician_id;

  DELETE FROM public.rating
  WHERE technician_id = p_technician_id;

  DELETE FROM public.technician_verification_state
  WHERE technician_id = p_technician_id;

  DELETE FROM public.technician
  WHERE technician_id = p_technician_id;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_delete_technician(BIGINT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.admin_delete_technician(BIGINT) TO authenticated;